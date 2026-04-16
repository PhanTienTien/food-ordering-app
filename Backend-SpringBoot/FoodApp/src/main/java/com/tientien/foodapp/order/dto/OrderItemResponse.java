package com.tientien.foodapp.order.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderItemResponse {

    private String name;
    private Integer quantity;
    private Double price;
}
