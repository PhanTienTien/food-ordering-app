package com.tientien.foodapp.order.service.impl;

import com.tientien.foodapp.cart.entity.Cart;
import com.tientien.foodapp.cart.entity.CartItem;
import com.tientien.foodapp.cart.repository.CartRepository;
import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.common.enums.UserRole;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.entity.OrderItem;
import com.tientien.foodapp.order.repository.OrderRepository;
import com.tientien.foodapp.order.service.OrderService;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class OrderServiceImpl implements OrderService {

    private final CartRepository cartRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;

    @Override
    public Order checkout(Long userId) {

        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found"));

        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        // 💣 Validate restaurant
        if (!cart.getRestaurant().getIsOpen()) {
            throw new RuntimeException("Restaurant is closed");
        }

        // 🔥 Tạo order
        Order order = new Order();
        order.setUser(cart.getUser());
        order.setRestaurant(cart.getRestaurant());
        order.setStatus(OrderStatus.PENDING);

        List<OrderItem> orderItems = new ArrayList<>();

        double total = 0;

        for (CartItem ci : cart.getItems()) {

            MenuItem mi = ci.getMenuItem();

            // 💣 Check stock
            if (mi.getStatus() != MenuItemStatus.AVAILABLE) {
                throw new RuntimeException("Item out of stock: " + mi.getName());
            }

            double price = mi.getDiscountPrice() != null
                    ? mi.getDiscountPrice()
                    : mi.getPrice();

            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setMenuItem(mi);
            oi.setQuantity(ci.getQuantity());
            oi.setPriceAtOrder(price);
            oi.setTotalPrice(price * ci.getQuantity());

            total += oi.getTotalPrice();

            orderItems.add(oi);
        }

        order.setItems(orderItems);
        order.setTotalPrice(total);
        order.setFinalPrice(total); // sau này add voucher

        Order savedOrder = orderRepository.save(order);

        // 🔥 clear cart
        cart.getItems().clear();
        cart.setRestaurant(null);

        return savedOrder;
    }

    @Override
    public Order updateStatus(Long orderId, OrderStatus newStatus, Long staffId) {

        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        User staff = userRepository.findById(staffId)
                .orElseThrow(() -> new RuntimeException("Staff not found"));

        // 💣 CHECK ROLE
        if (staff.getRole() != UserRole.STAFF) {
            throw new RuntimeException("Only staff can update order");
        }

        // 💣 CHECK RESTAURANT
        if (!order.getRestaurant().getId()
                .equals(staff.getRestaurant().getId())) {
            throw new RuntimeException("Not your restaurant order");
        }

        OrderStatus current = order.getStatus();

        // 💣 STATE MACHINE
        if (!isValidTransition(current, newStatus)) {
            throw new RuntimeException("Invalid status transition");
        }

        order.setStatus(newStatus);

        return orderRepository.save(order);
    }

    @Override
    public Order cancelOrder(Long orderId, Long userId) {

        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (!order.getUser().getId().equals(userId)) {
            throw new RuntimeException("Not your order");
        }

        if (order.getStatus() != OrderStatus.PENDING) {
            throw new RuntimeException("Cannot cancel this order");
        }

        order.setStatus(OrderStatus.CANCELLED);

        return orderRepository.save(order);
    }

    private boolean isValidTransition(OrderStatus current, OrderStatus next) {

        return switch (current) {

            case PENDING ->
                    next == OrderStatus.ACCEPTED ||
                            next == OrderStatus.REJECTED;

            case ACCEPTED ->
                    next == OrderStatus.PREPARING;

            case PREPARING ->
                    next == OrderStatus.READY;

            case READY ->
                    next == OrderStatus.DELIVERING;

            case DELIVERING ->
                    next == OrderStatus.COMPLETED;

            default -> false;
        };
    }

    // New methods for Phase 2
    @Override
    public Order checkoutWithDetails(com.tientien.foodapp.order.dto.CheckoutRequest request) {
        Cart cart = cartRepository.findByUserId(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Cart not found"));

        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        if (!cart.getRestaurant().getIsOpen()) {
            throw new RuntimeException("Restaurant is closed");
        }

        Order order = new Order();
        order.setUser(cart.getUser());
        order.setRestaurant(cart.getRestaurant());
        order.setStatus(OrderStatus.PENDING);

        // Set payment and shipping details
        order.setShippingAddress(request.getShippingAddress());
        order.setPhoneNumber(request.getPhoneNumber());
        order.setNote(request.getNote());
        order.setPaymentMethod(request.getPaymentMethod() != null ? 
                request.getPaymentMethod().name() : "COD");
        order.setPaymentStatus("PENDING");

        List<OrderItem> orderItems = new ArrayList<>();
        double total = 0;

        for (CartItem ci : cart.getItems()) {
            MenuItem mi = ci.getMenuItem();

            if (mi.getStatus() != MenuItemStatus.AVAILABLE) {
                throw new RuntimeException("Item out of stock: " + mi.getName());
            }

            double price = mi.getDiscountPrice() != null
                    ? mi.getDiscountPrice()
                    : mi.getPrice();

            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setMenuItem(mi);
            oi.setQuantity(ci.getQuantity());
            oi.setPriceAtOrder(price);
            oi.setTotalPrice(price * ci.getQuantity());

            total += oi.getTotalPrice();
            orderItems.add(oi);
        }

        order.setItems(orderItems);
        order.setTotalPrice(total);
        order.setFinalPrice(total); // TODO: Apply voucher discount

        Order savedOrder = orderRepository.save(order);

        // Clear cart
        cart.getItems().clear();
        cart.setRestaurant(null);
        cartRepository.save(cart);

        return savedOrder;
    }

    @Override
    public List<Order> getOrdersByUser(Long userId) {
        return orderRepository.findByUserId(userId);
    }

    @Override
    public Order getOrderById(Long orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    @Override
    public Order processPayment(Long orderId, com.tientien.foodapp.order.dto.PaymentRequest request) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        // Mock payment processing
        boolean paymentSuccess = request.isSimulateSuccess();

        if (paymentSuccess) {
            order.setPaymentStatus("PAID");
        } else {
            order.setPaymentStatus("FAILED");
        }

        return orderRepository.save(order);
    }

    @Override
    public List<Order> getOrdersByRestaurant(Long restaurantId) {
        return orderRepository.findByRestaurantId(restaurantId);
    }

    @Override
    public List<Order> getOrdersByRestaurantAndStatus(Long restaurantId, OrderStatus status) {
        return orderRepository.findByRestaurantIdAndStatus(restaurantId, status);
    }
}
