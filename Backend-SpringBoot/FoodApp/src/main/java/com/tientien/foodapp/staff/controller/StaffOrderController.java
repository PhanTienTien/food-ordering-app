package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.service.OrderService;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff/orders")
@RequiredArgsConstructor
public class StaffOrderController {

    private final OrderService orderService;
    private final UserRepository userRepository;

    // Get orders for staff's restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<Order> getRestaurantOrders(@PathVariable Long restaurantId) {
        // TODO: Verify staff belongs to this restaurant
        return orderService.getOrdersByRestaurant(restaurantId);
    }

    // Get orders by status for restaurant
    @GetMapping("/restaurant/{restaurantId}/status/{status}")
    public List<Order> getOrdersByStatus(
            @PathVariable Long restaurantId,
            @PathVariable OrderStatus status) {
        return orderService.getOrdersByRestaurantAndStatus(restaurantId, status);
    }

    // Accept order
    @PutMapping("/{orderId}/accept")
    public Order acceptOrder(
            @PathVariable Long orderId,
            @RequestParam Long staffId) {
        return orderService.updateStatus(orderId, OrderStatus.ACCEPTED, staffId);
    }

    // Reject order
    @PutMapping("/{orderId}/reject")
    public Order rejectOrder(
            @PathVariable Long orderId,
            @RequestParam Long staffId) {
        return orderService.updateStatus(orderId, OrderStatus.REJECTED, staffId);
    }

    // Update to preparing
    @PutMapping("/{orderId}/preparing")
    public Order markPreparing(
            @PathVariable Long orderId,
            @RequestParam Long staffId) {
        return orderService.updateStatus(orderId, OrderStatus.PREPARING, staffId);
    }

    // Mark ready for delivery
    @PutMapping("/{orderId}/ready")
    public Order markReady(
            @PathVariable Long orderId,
            @RequestParam Long staffId) {
        return orderService.updateStatus(orderId, OrderStatus.READY, staffId);
    }

    // Mark as delivered (when driver delivers)
    @PutMapping("/{orderId}/delivered")
    public Order markDelivered(
            @PathVariable Long orderId,
            @RequestParam Long staffId) {
        return orderService.updateStatus(orderId, OrderStatus.COMPLETED, staffId);
    }

    // Cancel order with reason
    @PutMapping("/{orderId}/cancel")
    public Order cancelOrder(
            @PathVariable Long orderId,
            @RequestParam Long staffId,
            @RequestParam String reason) {
        // TODO: Log cancellation reason
        return orderService.cancelOrder(orderId, staffId);
    }
}
