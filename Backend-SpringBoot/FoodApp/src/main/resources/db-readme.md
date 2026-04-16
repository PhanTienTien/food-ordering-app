# Food Ordering App - Database Setup Guide

## 📁 Files

| File | Mô tả |
|------|-------|
| `schema.sql` | Cấu trúc database (tables, foreign keys, indexes) |
| `data.sql` | Dữ liệu mẫu để test |

## 🚀 Cách chạy

### Bước 1: Tạo Database
```sql
CREATE DATABASE foodapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE foodapp;
```

### Bước 2: Chạy Schema
```bash
mysql -u root -p foodapp < schema.sql
```

Hoặc trong MySQL Workbench:
```sql
SOURCE schema.sql;
```

### Bước 3: Import Data (Optional)
```bash
mysql -u root -p foodapp < data.sql
```

## 📊 Cấu trúc Tables

### 1. `users` - Người dùng
```sql
id, name, email, password, role (ADMIN/STAFF/CUSTOMER), 
status (ACTIVE/SUSPENDED), restaurant_id (chỉ STAFF)
```

### 2. `restaurants` - Quán ăn
```sql
id, name, address, status (PENDING/APPROVED/REJECTED/SUSPENDED), 
is_open, latitude, longitude, delivery_radius
```

### 3. `categories` - Danh mục món ăn
```sql
id, name, image
```

### 4. `menu_items` - Món ăn
```sql
id, name, price, discount_price, status (AVAILABLE/OUT_OF_STOCK/HIDDEN), 
restaurant_id, category_id
```

### 5. `carts` & `cart_items` - Giỏ hàng
```sql
1 cart / 1 user, nhiều cart_items
```

### 6. `orders` & `order_items` - Đơn hàng
```sql
status: PENDING → ACCEPTED → PREPARING → READY → COMPLETED
```

### 7. `vouchers` - Mã giảm giá
```sql
code, discount_type (PERCENTAGE/FIXED), discount_value
```

## 🔑 Test Users

| Email | Password | Role |
|-------|----------|------|
| admin@foodapp.com | password | ADMIN |
| staff@phothin.com | password | STAFF (Phở Thìn) |
| staff@comtam.com | password | STAFF (Cơm Tấm) |
| customer1@gmail.com | password | CUSTOMER |
| customer2@gmail.com | password | CUSTOMER |
| customer3@gmail.com | password | CUSTOMER (Suspended) |

## 🧪 Test Vouchers

| Code | Giảm giá | Điều kiện |
|------|----------|-----------|
| GIAM10K | 10,000đ | Đơn từ 50,000đ |
| GIAM30K | 30,000đ | Đơn từ 100,000đ |
| SALE20 | 20% | Tối đa 50,000đ |
| FREESHIP | 30,000đ | Không giới hạn |
| WELCOME | 15,000đ | 1 lần/người |

## 🔗 Spring Boot Config

Trong `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/foodapp?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=validate
spring.sql.init.mode=never  # Không chạy schema/data.sql tự động
```

Hoặc để tự động chạy:
```properties
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql
```

## 📝 Ghi chú

- `role` trong users: `ADMIN`, `STAFF`, `CUSTOMER`
- `status` trong users: `ACTIVE`, `SUSPENDED`
- `status` trong restaurants: `PENDING`, `APPROVED`, `REJECTED`, `SUSPENDED`
- `status` trong menu_items: `AVAILABLE`, `OUT_OF_STOCK`, `HIDDEN`
- `status` trong orders: `PENDING`, `ACCEPTED`, `PREPARING`, `READY`, `DELIVERING`, `COMPLETED`, `REJECTED`, `CANCELLED`
