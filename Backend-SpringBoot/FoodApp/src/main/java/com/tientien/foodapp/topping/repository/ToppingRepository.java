package com.tientien.foodapp.topping.repository;

import com.tientien.foodapp.topping.entity.Topping;
import com.tientien.foodapp.topping.enums.ToppingStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ToppingRepository extends JpaRepository<Topping, Long> {
    List<Topping> findByRestaurantId(Long restaurantId);
    List<Topping> findByRestaurantIdAndStatus(Long restaurantId, ToppingStatus status);
    List<Topping> findByStatus(ToppingStatus status);
}
