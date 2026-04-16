package com.tientien.foodapp.cart.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartItemResponse {

    private Long menuItemId;
    private String name;
    private String image;

    private Double price;
    private Integer quantity;
    private Double totalPrice;
}
