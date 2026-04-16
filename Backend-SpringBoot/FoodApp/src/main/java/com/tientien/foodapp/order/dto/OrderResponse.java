package com.tientien.foodapp.order.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderResponse {

    private Long id;
    private String status;

    private Double totalPrice;
    private Double finalPrice;

    private List<OrderItemResponse> items;
}
