package com.tientien.foodapp.wallet.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.wallet.enums.TransactionType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "wallet_transactions")
@Getter
@Setter
public class WalletTransaction extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "wallet_id", nullable = false)
    private Wallet wallet;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionType type;

    @Column(nullable = false)
    private Double amount;

    @Column(nullable = false)
    private Double balanceAfter;

    private String description;

    private Long referenceId; // order_id, etc.

    private String referenceType; // "ORDER", "REFUND", "REWARD", etc.
}
