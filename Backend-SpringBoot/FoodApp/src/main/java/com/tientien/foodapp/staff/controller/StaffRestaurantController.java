package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import com.tientien.foodapp.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/staff/restaurant")
@RequiredArgsConstructor
public class StaffRestaurantController {

    private final RestaurantRepository restaurantRepository;

    // Toggle restaurant open/close status
    @PutMapping("/{restaurantId}/toggle-open")
    public Restaurant toggleOpenStatus(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(!restaurant.getIsOpen());
        return restaurantRepository.save(restaurant);
    }

    // Set restaurant as open
    @PutMapping("/{restaurantId}/open")
    public Restaurant openRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(true);
        return restaurantRepository.save(restaurant);
    }

    // Set restaurant as closed
    @PutMapping("/{restaurantId}/close")
    public Restaurant closeRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.setIsOpen(false);
        return restaurantRepository.save(restaurant);
    }

    // Get today's orders summary
    @GetMapping("/{restaurantId}/today-summary")
    public RestaurantTodaySummary getTodaySummary(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        // TODO: Implement actual summary logic
        return new RestaurantTodaySummary(0, 0.0, 0, 0);
    }

    private User requireStaff(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof User user) {
            return user;
        }
        throw new RuntimeException("Unauthorized");
    }

    private Long requireRestaurantId(User staff) {
        if (staff.getRestaurant() == null || staff.getRestaurant().getId() == null) {
            throw new RuntimeException("Staff is not assigned to a restaurant");
        }
        return staff.getRestaurant().getId();
    }

    private void verifyRestaurantAccess(User staff, Long restaurantId) {
        if (!restaurantId.equals(requireRestaurantId(staff))) {
            throw new RuntimeException("Not your restaurant");
        }
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
