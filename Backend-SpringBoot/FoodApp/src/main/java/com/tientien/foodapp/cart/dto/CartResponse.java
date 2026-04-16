package com.tientien.foodapp.cart.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class CartResponse {

    private Long id;
    private Long restaurantId;
    private String restaurantName;

    private List<CartItemResponse> items;

    private Double totalPrice;
}
