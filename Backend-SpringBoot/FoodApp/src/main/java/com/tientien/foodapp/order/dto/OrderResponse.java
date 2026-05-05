package com.tientien.foodapp.order.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
public class OrderResponse {

    private Long id;
    private String status;

    // Flattened user info
    private Long userId;
    private String userName;

    // Flattened restaurant info
    private Long restaurantId;
    private String restaurantName;

    private Double totalPrice;
    private Double finalPrice;

    // Payment fields
    private String paymentMethod;
    private String paymentStatus;
    private String shippingAddress;
    private String phoneNumber;
    private String note;
    private Double shippingFee;
    private Double discountAmount;
    private String voucherCode;

    private LocalDateTime createdAt;

    private List<OrderItemResponse> items;
}
