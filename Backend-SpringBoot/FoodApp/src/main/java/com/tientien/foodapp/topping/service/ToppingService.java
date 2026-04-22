package com.tientien.foodapp.topping.service;

import com.tientien.foodapp.topping.entity.Topping;
import com.tientien.foodapp.topping.enums.ToppingStatus;

import java.util.List;

public interface ToppingService {
    List<Topping> getAllToppings();
    Topping getToppingById(Long id);
    List<Topping> getToppingsByRestaurant(Long restaurantId);
    List<Topping> getAvailableToppingsByRestaurant(Long restaurantId);
    Topping createTopping(ToppingCreateRequest request);
    Topping updateTopping(Long id, ToppingUpdateRequest request);
    Topping updateStatus(Long id, ToppingStatus status);
    void deleteTopping(Long id);

    class ToppingCreateRequest {
        public String name;
        public Double price;
        public String description;
        public String image;
        public Long restaurantId;
    }

    class ToppingUpdateRequest {
        public String name;
        public Double price;
        public String description;
        public String image;
        public ToppingStatus status;
    }
}
