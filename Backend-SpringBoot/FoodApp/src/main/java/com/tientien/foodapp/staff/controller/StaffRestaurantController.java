package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/staff/restaurant")
@RequiredArgsConstructor
public class StaffRestaurantController {

    private final RestaurantRepository restaurantRepository;

    // Toggle restaurant open/close status
    @PutMapping("/{restaurantId}/toggle-open")
    public Restaurant toggleOpenStatus(@PathVariable Long restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(!restaurant.getIsOpen());
        return restaurantRepository.save(restaurant);
    }

    // Set restaurant as open
    @PutMapping("/{restaurantId}/open")
    public Restaurant openRestaurant(@PathVariable Long restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(true);
        return restaurantRepository.save(restaurant);
    }

    // Set restaurant as closed
    @PutMapping("/{restaurantId}/close")
    public Restaurant closeRestaurant(@PathVariable Long restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(false);
        return restaurantRepository.save(restaurant);
    }

    // Get today's orders summary
    @GetMapping("/{restaurantId}/today-summary")
    public RestaurantTodaySummary getTodaySummary(@PathVariable Long restaurantId) {
        // TODO: Implement actual summary logic
        return new RestaurantTodaySummary(0, 0.0, 0, 0);
    }

    @lombok.AllArgsConstructor
    @lombok.Data
    public static class RestaurantTodaySummary {
        private int totalOrders;
        private double totalRevenue;
        private int pendingOrders;
        private int completedOrders;
    }
}
