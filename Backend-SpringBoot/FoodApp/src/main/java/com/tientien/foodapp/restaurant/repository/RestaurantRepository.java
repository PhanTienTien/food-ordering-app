package com.tientien.foodapp.restaurant.repository;

import com.tientien.foodapp.restaurant.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    List<Restaurant> findByIsOpenTrue();

    List<Restaurant> findByStatus(String status);
}
