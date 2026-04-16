package com.tientien.foodapp.order.service;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.order.dto.CheckoutRequest;
import com.tientien.foodapp.order.dto.PaymentRequest;
import com.tientien.foodapp.order.entity.Order;

import java.util.List;

public interface OrderService {

    Order checkout(Long userId);

    Order checkoutWithDetails(CheckoutRequest request);

    Order updateStatus(Long orderId, OrderStatus newStatus, Long staffId);

    Order cancelOrder(Long orderId, Long userId);

    List<Order> getOrdersByUser(Long userId);

    Order getOrderById(Long orderId);

    Order processPayment(Long orderId, PaymentRequest request);

    // Staff methods
    List<Order> getOrdersByRestaurant(Long restaurantId);

    List<Order> getOrdersByRestaurantAndStatus(Long restaurantId, OrderStatus status);
}
