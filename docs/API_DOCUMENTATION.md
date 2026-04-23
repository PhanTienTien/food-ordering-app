# Food Ordering App - API Documentation

## Table of Contents
- [Overview](#overview)
- [Base URL](#base-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
  - [Authentication APIs](#authentication-apis)
  - [User Management](#user-management)
  - [Address Management](#address-management)
  - [Restaurant Management](#restaurant-management)
  - [Menu Item Management](#menu-item-management)
  - [Category Management](#category-management)
  - [Topping Management](#topping-management)
  - [Cart Management](#cart-management)
  - [Order Management](#order-management)
  - [Payment](#payment)
  - [Review Management](#review-management)
  - [Favorite Management](#favorite-management)
  - [Voucher Management](#voucher-management)
  - [Wallet Management](#wallet-management)
  - [Notification Management](#notification-management)
  - [Chat/Messaging](#chatmessaging)
  - [Dispute Management](#dispute-management)
  - [Shipper Management](#shipper-management)
  - [Order Tracking](#order-tracking)
  - [Banner Management](#banner-management)
  - [Commission Management](#commission-management)
  - [Admin APIs](#admin-apis)
  - [Staff APIs](#staff-apis)
- [Data Models](#data-models)
- [Enums](#enums)

---

## Overview

This is a comprehensive API documentation for the Food Ordering Application backend. The system is built with Spring Boot and provides RESTful APIs for a food delivery platform with multiple user roles: Admin, Staff, Customer, and Shipper.

### User Roles
- **ADMIN**: Full system access, manages users, restaurants, categories, reports
- **STAFF**: Restaurant staff, manages menu items, orders for their restaurant
- **CUSTOMER**: End users who order food, manage their orders, addresses, favorites
- **SHIPPER**: Delivery drivers who handle order deliveries

---

## Base URL

```
http://localhost:8080/api
```

---

## Authentication

Most endpoints require authentication. Include the JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

---

## API Endpoints

### Authentication APIs

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "string",
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "string"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "string",
  "message": "Login success"
}
```

---

### User Management

#### Get All Users (Admin)
```http
GET /api/admin/users
```

#### Get Users by Role (Admin)
```http
GET /api/admin/users/role/{role}
```
Role values: `ADMIN`, `STAFF`, `CUSTOMER`

#### Get User by ID (Admin)
```http
GET /api/admin/users/{id}
```

#### Lock User Account (Admin)
```http
PUT /api/admin/users/{id}/lock
```

#### Unlock User Account (Admin)
```http
PUT /api/admin/users/{id}/unlock
```

#### Create Staff User (Admin)
```http
POST /api/admin/users/staff
Content-Type: application/json

{
  "name": "string",
  "email": "string",
  "password": "string",
  "restaurantId": number
}
```

#### Delete User (Admin)
```http
DELETE /api/admin/users/{id}
```

---

### Address Management

#### Get Addresses by User
```http
GET /api/addresses/user/{userId}
```

#### Get Default Address
```http
GET /api/addresses/user/{userId}/default
```

#### Get Address by ID
```http
GET /api/addresses/{id}
```

#### Create Address
```http
POST /api/addresses
Content-Type: application/json

{
  "userId": number,
  "fullName": "string",
  "phoneNumber": "string",
  "addressLine": "string",
  "city": "string",
  "district": "string",
  "ward": "string",
  "latitude": number,
  "longitude": number,
  "isDefault": boolean
}
```

#### Update Address
```http
PUT /api/addresses/{id}
Content-Type: application/json

{
  "fullName": "string",
  "phoneNumber": "string",
  "addressLine": "string",
  "city": "string",
  "district": "string",
  "ward": "string",
  "latitude": number,
  "longitude": number
}
```

#### Set Default Address
```http
PUT /api/addresses/{id}/default?userId={userId}
```

#### Delete Address
```http
DELETE /api/addresses/{id}
```

---

### Restaurant Management

#### Get All Restaurants
```http
GET /api/restaurants
```

#### Get Restaurant by ID
```http
GET /api/restaurants/{id}
```

#### Get Open Restaurants
```http
GET /api/restaurants/open
```

#### Find Nearby Restaurants
```http
GET /api/restaurants/nearby?userLat={lat}&userLon={lon}&radiusKm={radius}
```
- `userLat`: User's latitude
- `userLon`: User's longitude
- `radiusKm`: Search radius in kilometers (default: 10.0)

**Response:**
```json
[
  {
    "restaurant": { /* Restaurant object */ },
    "distanceKm": number,
    "shippingFee": number
  }
]
```

#### Calculate Shipping Fee
```http
GET /api/restaurants/{id}/shipping-fee?userLat={lat}&userLon={lon}
```

---

### Menu Item Management

#### Get All Menu Items
```http
GET /api/menu-items
```

#### Get Menu Item by ID
```http
GET /api/menu-items/{id}
```

#### Get Menu Items by Restaurant
```http
GET /api/menu-items/restaurant/{restaurantId}
```

#### Get Menu Items by Category
```http
GET /api/menu-items/category/{categoryId}
```

#### Search Menu Items
```http
GET /api/menu-items/search?keyword={keyword}
```

#### Filter Menu Items (Advanced)
```http
GET /api/menu-items/filter?keyword={keyword}&restaurantId={id}&categoryId={id}&minPrice={price}&maxPrice={price}
```

#### Get Available Menu Items Only
```http
GET /api/menu-items/available
```

---

### Category Management

#### Get All Categories
```http
GET /api/categories
```

#### Get Category by ID
```http
GET /api/categories/{id}
```

---

### Topping Management

#### Get All Toppings
```http
GET /api/toppings
```

#### Get Topping by ID
```http
GET /api/toppings/{id}
```

#### Get Toppings by Restaurant
```http
GET /api/toppings/restaurant/{restaurantId}
```

#### Get Available Toppings by Restaurant
```http
GET /api/toppings/restaurant/{restaurantId}/available
```

#### Create Topping (Staff)
```http
POST /api/toppings
Content-Type: application/json

{
  "name": "string",
  "price": number,
  "description": "string",
  "image": "string",
  "restaurantId": number
}
```

#### Update Topping (Staff)
```http
PUT /api/toppings/{id}
Content-Type: application/json

{
  "name": "string",
  "price": number,
  "description": "string",
  "image": "string"
}
```

#### Update Topping Status (Staff)
```http
PUT /api/toppings/{id}/status?status={status}
```
Status values: `AVAILABLE`, `OUT_OF_STOCK`

#### Delete Topping (Staff)
```http
DELETE /api/toppings/{id}
```

---

### Cart Management

#### Add to Cart
```http
POST /api/cart/add?userId={userId}&menuItemId={menuItemId}&quantity={quantity}
```

#### Update Cart Item
```http
PUT /api/cart/update?userId={userId}&menuItemId={menuItemId}&quantity={quantity}
```

#### Get Cart
```http
GET /api/cart?userId={userId}
```

**Response:**
```json
{
  "id": number,
  "userId": number,
  "restaurantId": number,
  "items": [
    {
      "id": number,
      "menuItemId": number,
      "menuItemName": "string",
      "menuItemPrice": number,
      "quantity": number,
      "totalPrice": number
    }
  ],
  "totalPrice": number
}
```

#### Clear Cart
```http
DELETE /api/cart/clear?userId={userId}
```

---

### Order Management

#### Checkout (Create Order)
```http
POST /api/orders/checkout
Content-Type: application/json

{
  "userId": number,
  "shippingAddress": "string",
  "phoneNumber": "string",
  "note": "string",
  "paymentMethod": "COD|VNPAY|MOMO|CARD",
  "voucherCode": "string"
}
```

**Response:** Order object

#### Get My Orders
```http
GET /api/orders/my-orders?userId={userId}
```

#### Get Order by ID
```http
GET /api/orders/{id}
```

#### Process Payment
```http
POST /api/orders/{id}/pay
Content-Type: application/json

{
  "paymentMethod": "COD|VNPAY|MOMO|CARD"
}
```

#### Update Order Status (Staff)
```http
PUT /api/orders/{id}/status?staffId={staffId}&status={status}
```
Status values: `PENDING`, `ACCEPTED`, `PREPARING`, `READY`, `DELIVERING`, `COMPLETED`, `REJECTED`, `CANCELLED`

#### Cancel Order (Customer)
```http
PUT /api/orders/{id}/cancel?userId={userId}
```

---

### Payment

Payment methods are integrated into the order checkout process:
- **COD**: Cash on Delivery
- **VNPAY**: VNPay payment gateway
- **MOMO**: Momo e-wallet
- **CARD**: Credit/Debit card

---

### Review Management

#### Get All Reviews
```http
GET /api/reviews
```

#### Get Review by ID
```http
GET /api/reviews/{id}
```

#### Get Reviews by User
```http
GET /api/reviews/user/{userId}
```

#### Get Reviews by Menu Item
```http
GET /api/reviews/menu-item/{menuItemId}
```

#### Get Reviews by Restaurant
```http
GET /api/reviews/restaurant/{restaurantId}
```

#### Get Average Rating for Menu Item
```http
GET /api/reviews/menu-item/{menuItemId}/average-rating
```

#### Get Average Rating for Restaurant
```http
GET /api/reviews/restaurant/{restaurantId}/average-rating
```

#### Create Review
```http
POST /api/reviews
Content-Type: application/json

{
  "userId": number,
  "orderId": number,
  "rating": number,
  "comment": "string"
}
```

#### Update Review
```http
PUT /api/reviews/{id}
Content-Type: application/json

{
  "rating": number,
  "comment": "string"
}
```

#### Delete Review
```http
DELETE /api/reviews/{id}
```

---

### Favorite Management

#### Get All Favorites
```http
GET /api/favorites
```

#### Get Favorite by ID
```http
GET /api/favorites/{id}
```

#### Get Favorites by User
```http
GET /api/favorites/user/{userId}
```

#### Check if Menu Item is Favorite
```http
GET /api/favorites/check?userId={userId}&menuItemId={menuItemId}
```
**Response:** `boolean`

#### Add to Favorites
```http
POST /api/favorites?userId={userId}&menuItemId={menuItemId}
```

#### Remove from Favorites
```http
DELETE /api/favorites?userId={userId}&menuItemId={menuItemId}
```

---

### Voucher Management

#### Get All Vouchers
```http
GET /api/vouchers
```

#### Get Active Vouchers
```http
GET /api/vouchers/active
```

#### Get Voucher by ID
```http
GET /api/vouchers/{id}
```

#### Get Voucher by Code
```http
GET /api/vouchers/code/{code}
```

#### Create Voucher (Admin)
```http
POST /api/vouchers
Content-Type: application/json

{
  "code": "string",
  "discountType": "PERCENTAGE|FIXED_AMOUNT",
  "discountValue": number,
  "minOrderAmount": number,
  "maxDiscountAmount": number,
  "startDate": "string",
  "endDate": "string",
  "usageLimit": number
}
```

#### Update Voucher (Admin)
```http
PUT /api/vouchers/{id}
Content-Type: application/json

{
  "discountType": "PERCENTAGE|FIXED_AMOUNT",
  "discountValue": number,
  "minOrderAmount": number,
  "maxDiscountAmount": number,
  "startDate": "string",
  "endDate": "string",
  "usageLimit": number
}
```

#### Deactivate Voucher (Admin)
```http
PUT /api/vouchers/{id}/deactivate
```

#### Validate Voucher (Calculate Discount)
```http
POST /api/vouchers/validate?code={code}&orderAmount={amount}
```
**Response:** `number` (discount amount)

#### Use Voucher
```http
POST /api/vouchers/use?code={code}
```

---

### Wallet Management

#### Get Wallet by User
```http
GET /api/wallets/user/{userId}
```

#### Create Wallet
```http
POST /api/wallets/user/{userId}
```

#### Add Balance (Deposit)
```http
POST /api/wallets/user/{userId}/deposit?amount={amount}&description={description}
```

#### Deduct Balance
```http
POST /api/wallets/user/{userId}/deduct?amount={amount}&description={description}&referenceId={id}&referenceType={type}
```

#### Add Points
```http
POST /api/wallets/user/{userId}/points/add?points={points}
```

#### Redeem Points
```http
POST /api/wallets/user/{userId}/points/redeem?points={points}
```

#### Get Transaction History
```http
GET /api/wallets/user/{userId}/transactions
```

---

### Notification Management

#### Get Notifications by User
```http
GET /api/notifications/user/{userId}
```

#### Get Unread Notifications
```http
GET /api/notifications/user/{userId}/unread
```

#### Get Unread Count
```http
GET /api/notifications/user/{userId}/unread-count
```

#### Create Notification
```http
POST /api/notifications?userId={userId}&title={title}&message={message}&type={type}&referenceId={id}&referenceType={type}
```

#### Mark as Read
```http
PUT /api/notifications/{id}/read?userId={userId}
```

#### Mark All as Read
```http
PUT /api/notifications/user/{userId}/read-all
```

#### Delete Notification
```http
DELETE /api/notifications/{id}
```

---

### Chat/Messaging

#### Get Chat Rooms by User
```http
GET /api/chat/rooms/{userId}
```

#### Get Messages in Chat Room
```http
GET /api/chat/room/{id}/messages
```

#### Get Unread Messages
```http
GET /api/chat/room/{id}/unread
```

#### Create Chat Room
```http
POST /api/chat/room?user1Id={id}&user2Id={id}&type={type}&referenceId={id}
```
Type values: `DIRECT`, `ORDER`, `RESTAURANT`

#### Send Message
```http
POST /api/chat/room/{id}/message?senderId={senderId}&content={content}
```

#### Mark Message as Read
```http
PUT /api/chat/message/{id}/read
```

#### WebSocket (Real-time Messaging)
- **Send Message:** `ws://localhost:8080/ws/chat/{roomId}/send`
- **Subscribe to Messages:** `ws://localhost:8080/topic/chat/{roomId}`

---

### Dispute Management

#### Get All Disputes
```http
GET /api/disputes
```

#### Get Dispute by ID
```http
GET /api/disputes/{id}
```

#### Get Disputes by Order
```http
GET /api/disputes/order/{orderId}
```

#### Get Disputes by Status
```http
GET /api/disputes/status/{status}
```
Status values: `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED`

#### Create Dispute
```http
POST /api/disputes?orderId={orderId}&type={type}&description={description}
```
Type values: `MISSING_ITEMS`, `WRONG_ITEMS`, `QUALITY_ISSUE`, `DELIVERY_ISSUE`, `PAYMENT_ISSUE`

#### Resolve Dispute (Admin)
```http
PUT /api/disputes/{id}/resolve?resolution={resolution}&refundAmount={amount}&resolvedBy={userId}
```

#### Update Dispute Status
```http
PUT /api/disputes/{id}/status?status={status}
```

#### Delete Dispute
```http
DELETE /api/disputes/{id}
```

---

### Shipper Management

#### Get All Shippers
```http
GET /api/shippers
```

#### Get Shipper by ID
```http
GET /api/shippers/{id}
```

#### Get Available Shippers
```http
GET /api/shippers/available
```

#### Get Shippers by Status
```http
GET /api/shippers/status/{status}
```
Status values: `AVAILABLE`, `BUSY`, `OFFLINE`

#### Create Shipper (Admin)
```http
POST /api/shippers
Content-Type: application/json

{
  "name": "string",
  "phone": "string",
  "email": "string",
  "licensePlate": "string",
  "vehicleType": "string",
  "status": "AVAILABLE"
}
```

#### Update Shipper
```http
PUT /api/shippers/{id}
Content-Type: application/json

{
  "name": "string",
  "phone": "string",
  "email": "string",
  "licensePlate": "string",
  "vehicleType": "string",
  "status": "AVAILABLE",
  "latitude": number,
  "longitude": number,
  "isAvailable": boolean,
  "rating": number,
  "totalDeliveries": number
}
```

#### Update Shipper Location
```http
PUT /api/shippers/{id}/location?latitude={lat}&longitude={lon}
```

#### Update Shipper Status
```http
PUT /api/shippers/{id}/status?status={status}
```

#### Update Shipper Availability
```http
PUT /api/shippers/{id}/availability?isAvailable={true|false}
```

#### Delete Shipper
```http
DELETE /api/shippers/{id}
```

---

### Order Tracking

#### Update Location (REST)
```http
POST /api/tracking/{orderId}/update
Content-Type: application/json

{
  "latitude": number,
  "longitude": number,
  "status": "string"
}
```

#### Get Current Location
```http
GET /api/tracking/{orderId}
```

#### WebSocket (Real-time Tracking)
- **Update Location:** `ws://localhost:8080/ws/tracking/{orderId}/update`
- **Subscribe to Updates:** `ws://localhost:8080/topic/tracking/{orderId}`

---

### Banner Management

#### Get All Banners
```http
GET /api/admin/banners
```

#### Get Active Banners
```http
GET /api/admin/banners/active
```

#### Get Banner by ID
```http
GET /api/admin/banners/{id}
```

#### Create Banner (Admin)
```http
POST /api/admin/banners
Content-Type: application/json

{
  "title": "string",
  "description": "string",
  "imageUrl": "string",
  "targetUrl": "string",
  "status": "ACTIVE",
  "displayOrder": number,
  "startDate": "string",
  "endDate": "string"
}
```

#### Update Banner (Admin)
```http
PUT /api/admin/banners/{id}
Content-Type: application/json

{
  "title": "string",
  "description": "string",
  "imageUrl": "string",
  "targetUrl": "string",
  "status": "ACTIVE",
  "displayOrder": number,
  "startDate": "string",
  "endDate": "string"
}
```

#### Update Banner Status (Admin)
```http
PUT /api/admin/banners/{id}/status?status={status}
```
Status values: `ACTIVE`, `INACTIVE`, `EXPIRED`

#### Increment Click Count
```http
PUT /api/admin/banners/{id}/click
```

#### Delete Banner (Admin)
```http
DELETE /api/admin/banners/{id}
```

---

### Commission Management

#### Calculate Commission
```http
GET /api/admin/commissions/calculate?orderAmount={amount}
```

#### Create Payout (Admin)
```http
POST /api/admin/commissions/payouts?restaurantId={id}&amount={amount}&periodStart={date}&periodEnd={date}
```

#### Get Payouts by Restaurant
```http
GET /api/admin/commissions/payouts/restaurant/{restaurantId}
```

#### Get All Payouts
```http
GET /api/admin/commissions/payouts
```

#### Update Payout Status (Admin)
```http
PUT /api/admin/commissions/payouts/{id}/status?status={status}
```

#### Get Total Commission by Restaurant
```http
GET /api/admin/commissions/restaurant/{restaurantId}/total?startDate={date}&endDate={date}
```

---

### Admin APIs

#### Category Management (Admin)
- **Get All Categories:** `GET /api/admin/categories`
- **Get Category by ID:** `GET /api/admin/categories/{id}`
- **Create Category:** `POST /api/admin/categories`
- **Update Category:** `PUT /api/admin/categories/{id}`
- **Delete Category:** `DELETE /api/admin/categories/{id}`

#### Restaurant Management (Admin)
- **Get All Restaurants:** `GET /api/admin/restaurants`
- **Get Pending Restaurants:** `GET /api/admin/restaurants/pending`
- **Approve Restaurant:** `PUT /api/admin/restaurants/{id}/approve`
- **Reject Restaurant:** `PUT /api/admin/restaurants/{id}/reject`
- **Lock Restaurant:** `PUT /api/admin/restaurants/{id}/lock`
- **Unlock Restaurant:** `PUT /api/admin/restaurants/{id}/unlock`
- **Delete Restaurant:** `DELETE /api/admin/restaurants/{id}`

#### Reports (Admin)
- **Dashboard Summary:** `GET /api/admin/reports/dashboard`
- **Revenue Report:** `GET /api/admin/reports/revenue?startDate={date}&endDate={date}`
- **Top Restaurants:** `GET /api/admin/reports/top-restaurants?limit={number}`
- **Order Statistics:** `GET /api/admin/reports/order-stats`

---

### Staff APIs

#### Menu Management (Staff)
- **Get Restaurant Menu Items:** `GET /api/staff/menu-items/restaurant/{restaurantId}`
- **Toggle Item Status:** `PUT /api/staff/menu-items/{itemId}/toggle-status?status={status}`
- **Update Item Price:** `PUT /api/staff/menu-items/{itemId}/price?price={price}&discountPrice={price}`
- **Update Item Details:** `PUT /api/staff/menu-items/{itemId}`
- **Create Menu Item:** `POST /api/staff/menu-items`
- **Delete Menu Item:** `DELETE /api/staff/menu-items/{itemId}`

#### Order Management (Staff)
- **Get Restaurant Orders:** `GET /api/staff/orders/restaurant/{restaurantId}`
- **Get Orders by Status:** `GET /api/staff/orders/restaurant/{restaurantId}/status/{status}`
- **Accept Order:** `PUT /api/staff/orders/{orderId}/accept?staffId={id}`
- **Reject Order:** `PUT /api/staff/orders/{orderId}/reject?staffId={id}`
- **Mark Preparing:** `PUT /api/staff/orders/{orderId}/preparing?staffId={id}`
- **Mark Ready:** `PUT /api/staff/orders/{orderId}/ready?staffId={id}`
- **Mark Delivered:** `PUT /api/staff/orders/{orderId}/delivered?staffId={id}`
- **Cancel Order:** `PUT /api/staff/orders/{orderId}/cancel?staffId={id}&reason={reason}`

#### Restaurant Management (Staff)
- **Toggle Open Status:** `PUT /api/staff/restaurant/{restaurantId}/toggle-open`
- **Open Restaurant:** `PUT /api/staff/restaurant/{restaurantId}/open`
- **Close Restaurant:** `PUT /api/staff/restaurant/{restaurantId}/close`
- **Get Today's Summary:** `GET /api/staff/restaurant/{restaurantId}/today-summary`

---

## Data Models

### User
```json
{
  "id": number,
  "name": "string",
  "email": "string",
  "password": "string",
  "role": "ADMIN|STAFF|CUSTOMER",
  "status": "ACTIVE|SUSPENDED",
  "restaurantId": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Address
```json
{
  "id": number,
  "userId": number,
  "fullName": "string",
  "phoneNumber": "string",
  "addressLine": "string",
  "city": "string",
  "district": "string",
  "ward": "string",
  "latitude": number,
  "longitude": number,
  "isDefault": boolean,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Restaurant
```json
{
  "id": number,
  "name": "string",
  "address": "string",
  "status": "PENDING|APPROVED|REJECTED|SUSPENDED",
  "isOpen": boolean,
  "latitude": number,
  "longitude": number,
  "deliveryRadius": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### MenuItem
```json
{
  "id": number,
  "name": "string",
  "price": number,
  "discountPrice": number,
  "status": "AVAILABLE|OUT_OF_STOCK",
  "image": "string",
  "description": "string",
  "restaurantId": number,
  "categoryId": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Category
```json
{
  "id": number,
  "name": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Topping
```json
{
  "id": number,
  "name": "string",
  "price": number,
  "description": "string",
  "image": "string",
  "status": "AVAILABLE|OUT_OF_STOCK",
  "restaurantId": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Cart
```json
{
  "id": number,
  "userId": number,
  "restaurantId": number,
  "items": [
    {
      "id": number,
      "cartId": number,
      "menuItemId": number,
      "quantity": number
    }
  ],
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Order
```json
{
  "id": number,
  "userId": number,
  "restaurantId": number,
  "status": "PENDING|ACCEPTED|PREPARING|READY|DELIVERING|COMPLETED|REJECTED|CANCELLED",
  "totalPrice": number,
  "finalPrice": number,
  "items": [
    {
      "id": number,
      "orderId": number,
      "menuItemId": number,
      "quantity": number,
      "priceAtOrder": number,
      "totalPrice": number
    }
  ],
  "paymentMethod": "COD|VNPAY|MOMO|CARD",
  "paymentStatus": "PENDING|PAID|FAILED|REFUNDED",
  "shippingAddress": "string",
  "phoneNumber": "string",
  "note": "string",
  "shippingFee": number,
  "discountAmount": number,
  "voucherCode": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Review
```json
{
  "id": number,
  "userId": number,
  "orderId": number,
  "rating": number,
  "comment": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Favorite
```json
{
  "id": number,
  "userId": number,
  "menuItemId": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Voucher
```json
{
  "id": number,
  "code": "string",
  "discountType": "PERCENTAGE|FIXED_AMOUNT",
  "discountValue": number,
  "minOrderAmount": number,
  "maxDiscountAmount": number,
  "startDate": "string",
  "endDate": "string",
  "usageLimit": number,
  "usageCount": number,
  "status": "ACTIVE|INACTIVE|EXPIRED",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Wallet
```json
{
  "id": number,
  "userId": number,
  "balance": number,
  "points": number,
  "totalEarned": number,
  "totalSpent": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### WalletTransaction
```json
{
  "id": number,
  "walletId": number,
  "type": "DEPOSIT|WITHDRAWAL|ORDER_PAYMENT|REFUND|REWARD",
  "amount": number,
  "balanceAfter": number,
  "description": "string",
  "referenceId": number,
  "referenceType": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Notification
```json
{
  "id": number,
  "userId": number,
  "title": "string",
  "message": "string",
  "type": "ORDER|PAYMENT|DELIVERY|PROMOTION|SYSTEM",
  "referenceId": number,
  "referenceType": "string",
  "isRead": boolean,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### ChatRoom
```json
{
  "id": number,
  "user1Id": number,
  "user2Id": number,
  "type": "DIRECT|ORDER|RESTAURANT",
  "referenceId": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### ChatMessage
```json
{
  "id": number,
  "chatRoomId": number,
  "senderId": number,
  "content": "string",
  "isRead": boolean,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Dispute
```json
{
  "id": number,
  "orderId": number,
  "type": "MISSING_ITEMS|WRONG_ITEMS|QUALITY_ISSUE|DELIVERY_ISSUE|PAYMENT_ISSUE",
  "status": "OPEN|IN_PROGRESS|RESOLVED|CLOSED",
  "description": "string",
  "resolution": "string",
  "refundAmount": number,
  "resolvedBy": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Shipper
```json
{
  "id": number,
  "name": "string",
  "phone": "string",
  "email": "string",
  "licensePlate": "string",
  "vehicleType": "string",
  "status": "AVAILABLE|BUSY|OFFLINE",
  "latitude": number,
  "longitude": number,
  "isAvailable": boolean,
  "rating": number,
  "totalDeliveries": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Banner
```json
{
  "id": number,
  "title": "string",
  "description": "string",
  "imageUrl": "string",
  "targetUrl": "string",
  "status": "ACTIVE|INACTIVE|EXPIRED",
  "displayOrder": number,
  "startDate": "string",
  "endDate": "string",
  "clickCount": number,
  "createdAt": "string",
  "updatedAt": "string"
}
```

### Payout
```json
{
  "id": number,
  "restaurantId": number,
  "amount": number,
  "periodStart": "string",
  "periodEnd": "string",
  "status": "PENDING|PAID|CANCELLED",
  "createdAt": "string",
  "updatedAt": "string"
}
```

---

## Enums

### UserRole
- `ADMIN`: System administrator
- `STAFF`: Restaurant staff
- `CUSTOMER`: End user

### OrderStatus
- `PENDING`: Order created, waiting for restaurant acceptance
- `ACCEPTED`: Restaurant accepted the order
- `PREPARING`: Restaurant is preparing the food
- `READY`: Food is ready for pickup
- `DELIVERING`: Shipper is delivering the order
- `COMPLETED`: Order delivered successfully
- `REJECTED`: Restaurant rejected the order
- `CANCELLED`: Order cancelled by customer

### PaymentMethod
- `COD`: Cash on Delivery
- `VNPAY`: VNPay payment gateway
- `MOMO`: Momo e-wallet
- `CARD`: Credit/Debit card

### MenuItemStatus
- `AVAILABLE`: Item is available for order
- `OUT_OF_STOCK`: Item is temporarily unavailable

### ToppingStatus
- `AVAILABLE`: Topping is available
- `OUT_OF_STOCK`: Topping is temporarily unavailable

### VoucherStatus
- `ACTIVE`: Voucher is currently active
- `INACTIVE`: Voucher is inactive
- `EXPIRED`: Voucher has expired

### DiscountType
- `PERCENTAGE`: Discount is a percentage of order amount
- `FIXED_AMOUNT`: Discount is a fixed amount

### ShipperStatus
- `AVAILABLE`: Shipper is available for delivery
- `BUSY`: Shipper is currently on a delivery
- `OFFLINE`: Shipper is offline

### DisputeType
- `MISSING_ITEMS`: Items missing from order
- `WRONG_ITEMS`: Wrong items delivered
- `QUALITY_ISSUE`: Food quality issues
- `DELIVERY_ISSUE`: Delivery problems
- `PAYMENT_ISSUE`: Payment related issues

### DisputeStatus
- `OPEN`: Dispute created, awaiting resolution
- `IN_PROGRESS`: Dispute is being reviewed
- `RESOLVED`: Dispute has been resolved
- `CLOSED`: Dispute closed without resolution

### NotificationType
- `ORDER`: Order related notifications
- `PAYMENT`: Payment related notifications
- `DELIVERY`: Delivery related notifications
- `PROMOTION`: Promotional notifications
- `SYSTEM`: System notifications

### ChatRoomType
- `DIRECT`: Direct chat between users
- `ORDER`: Chat related to an order
- `RESTAURANT`: Chat with restaurant

### TransactionType
- `DEPOSIT`: Money added to wallet
- `WITHDRAWAL`: Money withdrawn from wallet
- `ORDER_PAYMENT`: Payment for order
- `REFUND`: Refund to wallet
- `REWARD`: Reward points added

### BannerStatus
- `ACTIVE`: Banner is currently displayed
- `INACTIVE`: Banner is not displayed
- `EXPIRED`: Banner has expired

---

## Notes

1. **Authentication**: Most endpoints require JWT token in Authorization header
2. **Date Format**: All dates are in ISO 8601 format (YYYY-MM-DDTHH:mm:ss)
3. **Pagination**: Not currently implemented, but endpoints return full lists
4. **Error Handling**: Errors return JSON with error message
5. **WebSocket**: Real-time features use WebSocket for chat and tracking
6. **File Upload**: Image upload endpoints are not documented here (need to check implementation)
7. **Validation**: Request bodies are validated, invalid requests return 400 Bad Request

---

## Common Response Codes

- `200 OK`: Request successful
- `201 Created`: Resource created successfully
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Missing or invalid authentication
- `403 Forbidden`: User doesn't have permission
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

---

## Contact

For questions or issues, please contact the backend development team.
