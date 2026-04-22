package com.tientien.foodapp.commission.service;

import com.tientien.foodapp.commission.entity.Payout;
import com.tientien.foodapp.order.entity.Order;

import java.util.List;

public interface CommissionService {
    Double calculateCommission(Double orderAmount);
    Payout createPayout(Long restaurantId, Double amount, String periodStart, String periodEnd);
    List<Payout> getPayoutsByRestaurant(Long restaurantId);
    List<Payout> getAllPayouts();
    Payout updatePayoutStatus(Long id, String status);
    Double getTotalCommissionByRestaurant(Long restaurantId, String startDate, String endDate);
}
