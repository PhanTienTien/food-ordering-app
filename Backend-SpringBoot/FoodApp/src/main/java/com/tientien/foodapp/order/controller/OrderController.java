package com.tientien.foodapp.order.controller;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.common.enums.PaymentMethod;
import com.tientien.foodapp.order.dto.CheckoutRequest;
import com.tientien.foodapp.order.dto.PaymentRequest;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    // Checkout with full details
    @PostMapping("/checkout")
    public Order checkout(@RequestBody CheckoutRequest request) {
        return orderService.checkoutWithDetails(request);
    }

    // Get order history for user
    @GetMapping("/my-orders")
    public List<Order> getMyOrders(@RequestParam Long userId) {
        return orderService.getOrdersByUser(userId);
    }

    // Get order details
    @GetMapping("/{id}")
    public Order getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id);
    }

    // Process payment
    @PostMapping("/{id}/pay")
    public Order processPayment(
            @PathVariable Long id,
            @RequestBody PaymentRequest request) {
        return orderService.processPayment(id, request);
    }

    // Update order status (for staff)
    @PutMapping("/{id}/status")
    public Order updateStatus(
            @PathVariable Long id,
            @RequestParam Long staffId,
            @RequestParam OrderStatus status
    ) {
        return orderService.updateStatus(id, status, staffId);
    }

    // Cancel order
    @PutMapping("/{id}/cancel")
    public Order cancel(
            @PathVariable Long id,
            @RequestParam Long userId
    ) {
        return orderService.cancelOrder(id, userId);
    }
}
