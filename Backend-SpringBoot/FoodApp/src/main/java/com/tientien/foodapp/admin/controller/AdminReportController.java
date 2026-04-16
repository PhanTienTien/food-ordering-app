package com.tientien.foodapp.admin.controller;

import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.repository.OrderRepository;
import com.tientien.foodapp.user.repository.UserRepository;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/reports")
@RequiredArgsConstructor
public class AdminReportController {

    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final RestaurantRepository restaurantRepository;

    // Dashboard summary
    @GetMapping("/dashboard")
    public DashboardSummary getDashboardSummary() {
        long totalOrders = orderRepository.count();
        long totalUsers = userRepository.count();
        long totalRestaurants = restaurantRepository.count();
        
        List<Order> todayOrders = orderRepository.findByCreatedAtBetween(
                LocalDateTime.of(LocalDate.now(), LocalTime.MIN),
                LocalDateTime.of(LocalDate.now(), LocalTime.MAX)
        );
        
        double todayRevenue = todayOrders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .mapToDouble(Order::getFinalPrice)
                .sum();
        
        return new DashboardSummary(
                totalOrders,
                totalUsers,
                totalRestaurants,
                todayOrders.size(),
                todayRevenue
        );
    }

    // Revenue report by date range
    @GetMapping("/revenue")
    public RevenueReport getRevenueReport(
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate) {
        
        LocalDateTime start = startDate.atStartOfDay();
        LocalDateTime end = endDate.atTime(LocalTime.MAX);
        
        List<Order> orders = orderRepository.findByCreatedAtBetween(start, end);
        
        double totalRevenue = orders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .mapToDouble(Order::getFinalPrice)
                .sum();
        
        Map<String, Double> dailyRevenue = orders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .collect(Collectors.groupingBy(
                        o -> o.getCreatedAt().toLocalDate().toString(),
                        Collectors.summingDouble(Order::getFinalPrice)
                ));
        
        return new RevenueReport(startDate, endDate, totalRevenue, dailyRevenue);
    }

    // Top restaurants by orders
    @GetMapping("/top-restaurants")
    public List<RestaurantRanking> getTopRestaurants(
            @RequestParam(defaultValue = "10") int limit) {
        
        List<Order> completedOrders = orderRepository.findByStatus(OrderStatus.COMPLETED);
        
        Map<Long, Long> restaurantOrderCounts = completedOrders.stream()
                .collect(Collectors.groupingBy(
                        o -> o.getRestaurant().getId(),
                        Collectors.counting()
                ));
        
        Map<Long, Double> restaurantRevenue = completedOrders.stream()
                .collect(Collectors.groupingBy(
                        o -> o.getRestaurant().getId(),
                        Collectors.summingDouble(Order::getFinalPrice)
                ));
        
        return restaurantOrderCounts.entrySet().stream()
                .sorted(Map.Entry.<Long, Long>comparingByValue().reversed())
                .limit(limit)
                .map(e -> new RestaurantRanking(
                        e.getKey(),
                        e.getValue(),
                        restaurantRevenue.getOrDefault(e.getKey(), 0.0)
                ))
                .collect(Collectors.toList());
    }

    // Order statistics by status
    @GetMapping("/order-stats")
    public Map<String, Long> getOrderStats() {
        Map<String, Long> stats = new HashMap<>();
        for (OrderStatus status : OrderStatus.values()) {
            stats.put(status.name(), orderRepository.countByStatus(status));
        }
        return stats;
    }

    // Response DTOs
    @lombok.AllArgsConstructor
    @lombok.Data
    public static class DashboardSummary {
        private long totalOrders;
        private long totalUsers;
        private long totalRestaurants;
        private long todayOrders;
        private double todayRevenue;
    }

    @lombok.AllArgsConstructor
    @lombok.Data
    public static class RevenueReport {
        private LocalDate startDate;
        private LocalDate endDate;
        private double totalRevenue;
        private Map<String, Double> dailyRevenue;
    }

    @lombok.AllArgsConstructor
    @lombok.Data
    public static class RestaurantRanking {
        private Long restaurantId;
        private long orderCount;
        private double totalRevenue;
    }
}
