package com.tientien.foodapp.order.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.common.enums.OrderStatus;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "orders")
@Getter
@Setter
public class Order extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    private Double totalPrice;
    private Double finalPrice;

    @OneToMany(
            mappedBy = "order",
            cascade = CascadeType.ALL
    )
    private List<OrderItem> items;

    // Payment fields
    private String paymentMethod; // COD, VNPAY, MOMO, CARD
    private String paymentStatus; // PENDING, PAID, FAILED, REFUNDED
    private String shippingAddress;
    private String phoneNumber;
    private String note;
    private Double shippingFee;
    private Double discountAmount;
    private String voucherCode;
}
