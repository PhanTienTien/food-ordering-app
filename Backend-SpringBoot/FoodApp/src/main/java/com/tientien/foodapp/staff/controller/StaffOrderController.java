package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.service.OrderService;
import com.tientien.foodapp.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff/orders")
@RequiredArgsConstructor
public class StaffOrderController {

    private final OrderService orderService;

    // Get orders for staff's restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<Order> getRestaurantOrders(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        return orderService.getOrdersByRestaurant(restaurantId);
    }

    // Get orders by status for restaurant
    @GetMapping("/restaurant/{restaurantId}/status/{status}")
    public List<Order> getOrdersByStatus(
            @PathVariable Long restaurantId,
            @PathVariable OrderStatus status,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        return orderService.getOrdersByRestaurantAndStatus(restaurantId, status);
    }

    // Accept order
    @PutMapping("/{orderId}/accept")
    public Order acceptOrder(
            @PathVariable Long orderId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        return orderService.updateStatus(orderId, OrderStatus.ACCEPTED, staff.getId());
    }

    // Reject order
    @PutMapping("/{orderId}/reject")
    public Order rejectOrder(
            @PathVariable Long orderId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        return orderService.updateStatus(orderId, OrderStatus.REJECTED, staff.getId());
    }

    // Update to preparing
    @PutMapping("/{orderId}/preparing")
    public Order markPreparing(
            @PathVariable Long orderId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        return orderService.updateStatus(orderId, OrderStatus.PREPARING, staff.getId());
    }

    // Mark ready for delivery
    @PutMapping("/{orderId}/ready")
    public Order markReady(
            @PathVariable Long orderId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        return orderService.updateStatus(orderId, OrderStatus.READY, staff.getId());
    }

    // Mark as delivered (when driver delivers)
    @PutMapping("/{orderId}/delivered")
    public Order markDelivered(
            @PathVariable Long orderId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        return orderService.updateStatus(orderId, OrderStatus.COMPLETED, staff.getId());
    }

    // Cancel order with reason
    @PutMapping("/{orderId}/cancel")
    public Order cancelOrder(
            @PathVariable Long orderId,
            @RequestParam String reason,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        // TODO: Log cancellation reason
        return orderService.cancelOrder(orderId, staff.getId());
    }

    private User requireStaff(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof User user) {
            return user;
        }
        throw new RuntimeException("Unauthorized");
    }

    private void verifyRestaurantAccess(User staff, Long restaurantId) {
        if (staff.getRestaurant() == null ||
                !restaurantId.equals(staff.getRestaurant().getId())) {
            throw new RuntimeException("Not your restaurant");
        }
    }
}
