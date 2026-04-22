package com.tientien.foodapp.commission.service.impl;

import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.commission.entity.Payout;
import com.tientien.foodapp.commission.enums.PayoutStatus;
import com.tientien.foodapp.commission.repository.PayoutRepository;
import com.tientien.foodapp.commission.service.CommissionService;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.repository.OrderRepository;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CommissionServiceImpl implements CommissionService {

    private final PayoutRepository payoutRepository;
    private final RestaurantRepository restaurantRepository;
    private final OrderRepository orderRepository;

    private static final Double COMMISSION_RATE = 0.10; // 10% commission
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public Double calculateCommission(Double orderAmount) {
        return orderAmount * COMMISSION_RATE;
    }

    @Override
    public Payout createPayout(
            Long restaurantId,
            Double amount,
            String periodStart,
            String periodEnd) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new NotFoundException("Restaurant not found"));

        Double commissionAmount = calculateCommission(amount);
        Double netAmount = amount - commissionAmount;

        Payout payout = new Payout();
        payout.setRestaurant(restaurant);
        payout.setAmount(amount);
        payout.setCommissionAmount(commissionAmount);
        payout.setNetAmount(netAmount);
        payout.setStatus(PayoutStatus.PENDING);
        payout.setPeriodStart(periodStart != null ? LocalDateTime.parse(periodStart, formatter) : null);
        payout.setPeriodEnd(periodEnd != null ? LocalDateTime.parse(periodEnd, formatter) : null);

        return payoutRepository.save(payout);
    }

    @Override
    public List<Payout> getPayoutsByRestaurant(Long restaurantId) {
        return payoutRepository.findByRestaurantId(restaurantId);
    }

    @Override
    public List<Payout> getAllPayouts() {
        return payoutRepository.findAll();
    }

    @Override
    public Payout updatePayoutStatus(Long id, String status) {
        Payout payout = payoutRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Payout not found"));
        payout.setStatus(PayoutStatus.valueOf(status));
        return payoutRepository.save(payout);
    }

    @Override
    public Double getTotalCommissionByRestaurant(Long restaurantId, String startDate, String endDate) {
        LocalDateTime start = LocalDateTime.parse(startDate, formatter);
        LocalDateTime end = LocalDateTime.parse(endDate, formatter);

        List<Order> orders = orderRepository.findByRestaurantIdAndCreatedAtBetween(
                restaurantId, start, end);

        return orders.stream()
                .filter(o -> o.getStatus().name().equals("COMPLETED"))
                .mapToDouble(Order::getFinalPrice)
                .map(this::calculateCommission)
                .sum();
    }
}
