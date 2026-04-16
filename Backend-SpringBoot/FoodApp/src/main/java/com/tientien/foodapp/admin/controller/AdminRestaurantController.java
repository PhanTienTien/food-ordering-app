package com.tientien.foodapp.admin.controller;

import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/restaurants")
@RequiredArgsConstructor
public class AdminRestaurantController {

    private final RestaurantRepository restaurantRepository;

    // Get all restaurants
    @GetMapping
    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    // Get pending approval restaurants
    @GetMapping("/pending")
    public List<Restaurant> getPendingRestaurants() {
        return restaurantRepository.findByStatus("PENDING");
    }

    // Approve restaurant
    @PutMapping("/{id}/approve")
    public Restaurant approveRestaurant(@PathVariable Long id) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setStatus("APPROVED");
        restaurant.setIsOpen(true);
        return restaurantRepository.save(restaurant);
    }

    // Reject restaurant
    @PutMapping("/{id}/reject")
    public Restaurant rejectRestaurant(@PathVariable Long id) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setStatus("REJECTED");
        return restaurantRepository.save(restaurant);
    }

    // Lock/Suspend restaurant
    @PutMapping("/{id}/lock")
    public Restaurant lockRestaurant(@PathVariable Long id) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setStatus("SUSPENDED");
        restaurant.setIsOpen(false);
        return restaurantRepository.save(restaurant);
    }

    // Unlock restaurant
    @PutMapping("/{id}/unlock")
    public Restaurant unlockRestaurant(@PathVariable Long id) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setStatus("APPROVED");
        return restaurantRepository.save(restaurant);
    }

    // Delete restaurant
    @DeleteMapping("/{id}")
    public void deleteRestaurant(@PathVariable Long id) {
        restaurantRepository.deleteById(id);
    }
}
