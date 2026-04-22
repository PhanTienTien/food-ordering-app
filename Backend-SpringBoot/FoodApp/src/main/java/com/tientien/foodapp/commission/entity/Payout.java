package com.tientien.foodapp.commission.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.commission.enums.PayoutStatus;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "payouts")
@Getter
@Setter
public class Payout extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @Column(nullable = false)
    private Double amount;

    @Column(nullable = false)
    private Double commissionAmount;

    @Column(nullable = false)
    private Double netAmount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PayoutStatus status;

    private LocalDateTime periodStart;

    private LocalDateTime periodEnd;

    private String transactionId; // Bank transaction ID

    private String bankAccount;

    private String bankName;
}
