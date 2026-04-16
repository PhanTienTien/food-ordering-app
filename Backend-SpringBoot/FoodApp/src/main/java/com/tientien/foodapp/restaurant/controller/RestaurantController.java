package com.tientien.foodapp.restaurant.controller;

import com.tientien.foodapp.common.utils.LocationUtils;
import com.tientien.foodapp.restaurant.dto.RestaurantDistanceDTO;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/restaurants")
@RequiredArgsConstructor
public class RestaurantController {

    private final RestaurantRepository restaurantRepository;

    // Get all restaurants
    @GetMapping
    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    // Get restaurant by ID
    @GetMapping("/{id}")
    public Restaurant getRestaurantById(@PathVariable Long id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
    }

    // Get open restaurants only
    @GetMapping("/open")
    public List<Restaurant> getOpenRestaurants() {
        return restaurantRepository.findByIsOpenTrue();
    }

    // Find nearby restaurants with distance
    @GetMapping("/nearby")
    public List<RestaurantDistanceDTO> findNearbyRestaurants(
            @RequestParam double userLat,
            @RequestParam double userLon,
            @RequestParam(defaultValue = "10.0") double radiusKm) {

        List<Restaurant> restaurants = restaurantRepository.findByIsOpenTrue();

        return restaurants.stream()
                .filter(r -> r.getLatitude() != null && r.getLongitude() != null)
                .map(r -> {
                    double distance = LocationUtils.calculateDistance(
                            userLat, userLon, r.getLatitude(), r.getLongitude());
                    double shippingFee = LocationUtils.calculateShippingFee(distance);
                    return new RestaurantDistanceDTO(r, distance, shippingFee);
                })
                .filter(dto -> dto.getDistanceKm() <= radiusKm)
                .sorted(Comparator.comparingDouble(RestaurantDistanceDTO::getDistanceKm))
                .collect(Collectors.toList());
    }

    // Calculate shipping fee for a restaurant
    @GetMapping("/{id}/shipping-fee")
    public double calculateShippingFee(
            @PathVariable Long id,
            @RequestParam double userLat,
            @RequestParam double userLon) {

        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (restaurant.getLatitude() == null || restaurant.getLongitude() == null) {
            throw new RuntimeException("Restaurant location not available");
        }

        double distance = LocationUtils.calculateDistance(
                userLat, userLon,
                restaurant.getLatitude(), restaurant.getLongitude());

        return LocationUtils.calculateShippingFee(distance);
    }
}
