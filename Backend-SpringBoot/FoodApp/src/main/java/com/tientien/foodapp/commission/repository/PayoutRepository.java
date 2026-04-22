package com.tientien.foodapp.commission.repository;

import com.tientien.foodapp.commission.entity.Payout;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PayoutRepository extends JpaRepository<Payout, Long> {
    List<Payout> findByRestaurantId(Long restaurantId);
}
