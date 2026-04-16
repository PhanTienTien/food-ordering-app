package com.tientien.foodapp.restaurant.dto;

import com.tientien.foodapp.restaurant.entity.Restaurant;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class RestaurantDistanceDTO {
    private Restaurant restaurant;
    private double distanceKm;
    private double shippingFee;
}
