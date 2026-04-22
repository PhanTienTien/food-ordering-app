package com.tientien.foodapp.dispute.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.dispute.enums.DisputeStatus;
import com.tientien.foodapp.dispute.enums.DisputeType;
import com.tientien.foodapp.order.entity.Order;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "disputes")
@Getter
@Setter
public class Dispute extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DisputeType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DisputeStatus status;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    private String resolution;

    private Double refundAmount;

    private Long resolvedBy; // Admin user ID
}
