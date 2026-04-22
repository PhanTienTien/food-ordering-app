package com.tientien.foodapp.commission.controller;

import com.tientien.foodapp.commission.entity.Payout;
import com.tientien.foodapp.commission.service.CommissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/commissions")
@RequiredArgsConstructor
public class CommissionController {

    private final CommissionService commissionService;

    @GetMapping("/calculate")
    public Double calculateCommission(@RequestParam Double orderAmount) {
        return commissionService.calculateCommission(orderAmount);
    }

    @PostMapping("/payouts")
    public Payout createPayout(
            @RequestParam Long restaurantId,
            @RequestParam Double amount,
            @RequestParam String periodStart,
            @RequestParam String periodEnd) {
        return commissionService.createPayout(restaurantId, amount, periodStart, periodEnd);
    }

    @GetMapping("/payouts/restaurant/{restaurantId}")
    public List<Payout> getPayoutsByRestaurant(@PathVariable Long restaurantId) {
        return commissionService.getPayoutsByRestaurant(restaurantId);
    }

    @GetMapping("/payouts")
    public List<Payout> getAllPayouts() {
        return commissionService.getAllPayouts();
    }

    @PutMapping("/payouts/{id}/status")
    public Payout updatePayoutStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return commissionService.updatePayoutStatus(id, status);
    }

    @GetMapping("/restaurant/{restaurantId}/total")
    public Double getTotalCommissionByRestaurant(
            @PathVariable Long restaurantId,
            @RequestParam String startDate,
            @RequestParam String endDate) {
        return commissionService.getTotalCommissionByRestaurant(restaurantId, startDate, endDate);
    }
}
