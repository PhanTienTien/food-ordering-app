package com.tientien.foodapp.review.repository;

import com.tientien.foodapp.review.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByOrderId(Long orderId);
    List<Review> findByUserId(Long userId);
    List<Review> findByMenuItemId(Long menuItemId);
    List<Review> findByRestaurantId(Long restaurantId);
    Optional<Review> findByOrderIdAndUserId(Long orderId, Long userId);
}
