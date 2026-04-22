package com.tientien.foodapp.wallet.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "wallets")
@Getter
@Setter
public class Wallet extends BaseEntity {

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(nullable = false)
    private Double balance = 0.0;

    @Column(nullable = false)
    private Integer points = 0;

    @Column(nullable = false)
    private Double totalEarned = 0.0;

    @Column(nullable = false)
    private Double totalSpent = 0.0;
}
