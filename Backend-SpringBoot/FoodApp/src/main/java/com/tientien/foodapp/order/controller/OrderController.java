package com.tientien.foodapp.order.controller;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.order.dto.CheckoutRequest;
import com.tientien.foodapp.order.dto.OrderItemResponse;
import com.tientien.foodapp.order.dto.OrderResponse;
import com.tientien.foodapp.order.dto.PaymentRequest;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.entity.OrderItem;
import com.tientien.foodapp.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    // Checkout with full details
    @PostMapping("/checkout")
    public OrderResponse checkout(@RequestBody CheckoutRequest request) {
        return toDto(orderService.checkoutWithDetails(request));
    }

    // Get order history for user
    @GetMapping("/my-orders")
    public List<OrderResponse> getMyOrders(@RequestParam Long userId) {
        return orderService.getOrdersByUser(userId).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Get order details
    @GetMapping("/{id}")
    public OrderResponse getOrderById(@PathVariable Long id) {
        return toDto(orderService.getOrderById(id));
    }

    // Process payment
    @PostMapping("/{id}/pay")
    public OrderResponse processPayment(
            @PathVariable Long id,
            @RequestBody PaymentRequest request) {
        return toDto(orderService.processPayment(id, request));
    }

    // Update order status (for staff)
    @PutMapping("/{id}/status")
    public OrderResponse updateStatus(
            @PathVariable Long id,
            @RequestParam Long staffId,
            @RequestParam OrderStatus status
    ) {
        return toDto(orderService.updateStatus(id, status, staffId));
    }

    // Cancel order
    @PutMapping("/{id}/cancel")
    public OrderResponse cancel(
            @PathVariable Long id,
            @RequestParam Long userId
    ) {
        return toDto(orderService.cancelOrder(id, userId));
    }

    private OrderResponse toDto(Order order) {
        if (order == null) return null;

        OrderResponse dto = new OrderResponse();
        dto.setId(order.getId());
        dto.setStatus(order.getStatus() != null ? order.getStatus().name() : null);

        // Flatten user info
        if (order.getUser() != null) {
            dto.setUserId(order.getUser().getId());
            dto.setUserName(order.getUser().getName());
        }

        // Flatten restaurant info
        if (order.getRestaurant() != null) {
            dto.setRestaurantId(order.getRestaurant().getId());
            dto.setRestaurantName(order.getRestaurant().getName());
        }

        dto.setTotalPrice(order.getTotalPrice());
        dto.setFinalPrice(order.getFinalPrice());

        // Payment fields
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setPaymentStatus(order.getPaymentStatus());
        dto.setShippingAddress(order.getShippingAddress());
        dto.setPhoneNumber(order.getPhoneNumber());
        dto.setNote(order.getNote());
        dto.setShippingFee(order.getShippingFee());
        dto.setDiscountAmount(order.getDiscountAmount());
        dto.setVoucherCode(order.getVoucherCode());

        dto.setCreatedAt(order.getCreatedAt());

        // Map order items
        if (order.getItems() != null) {
            dto.setItems(order.getItems().stream()
                    .map(this::toOrderItemDto)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    private OrderItemResponse toOrderItemDto(OrderItem item) {
        if (item == null) return null;

        OrderItemResponse dto = new OrderItemResponse();
        dto.setId(item.getId());
        dto.setQuantity(item.getQuantity());
        dto.setPriceAtOrder(item.getPriceAtOrder());
        dto.setTotalPrice(item.getTotalPrice());

        // Build nested menuItem
        if (item.getMenuItem() != null) {
            OrderItemResponse.MenuItemSummary menuItem = new OrderItemResponse.MenuItemSummary();
            menuItem.setId(item.getMenuItem().getId());
            menuItem.setName(item.getMenuItem().getName());
            menuItem.setImage(item.getMenuItem().getImage());
            menuItem.setPrice(item.getMenuItem().getPrice());
            menuItem.setDiscountPrice(item.getMenuItem().getDiscountPrice());
            dto.setMenuItem(menuItem);
        }

        return dto;
    }
}
