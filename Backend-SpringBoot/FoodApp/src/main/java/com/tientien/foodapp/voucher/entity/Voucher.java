package com.tientien.foodapp.voucher.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.voucher.enums.DiscountType;
import com.tientien.foodapp.voucher.enums.VoucherStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "vouchers")
@Getter
@Setter
public class Voucher extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String code;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DiscountType discountType;

    @Column(nullable = false)
    private Double discountValue;

    @Column(nullable = false)
    private Double minOrderAmount = 0.0;

    private Double maxDiscountAmount;

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    private Integer usageLimit;

    @Column(nullable = false)
    private Integer usageCount = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private VoucherStatus status;
}
