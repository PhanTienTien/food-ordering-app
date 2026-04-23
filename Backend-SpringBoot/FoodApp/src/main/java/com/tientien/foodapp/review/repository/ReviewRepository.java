package com.tientien.foodapp.review.repository;

import com.tientien.foodapp.review.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByOrderId(Long orderId);
    List<Review> findByUserId(Long userId);
    List<Review> findByOrderRestaurantId(Long restaurantId);
    Optional<Review> findByOrderIdAndUserId(Long orderId, Long userId);

    @Query("SELECT r FROM Review r JOIN r.order o JOIN o.items oi WHERE oi.menuItem.id = :menuItemId")
    List<Review> findByMenuItemId(@Param("menuItemId") Long menuItemId);
}
