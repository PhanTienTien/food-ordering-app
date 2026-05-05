package com.tientien.foodapp.cart.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartItemResponse {

    private Long id;
    private MenuItemSummary menuItem;
    private Integer quantity;
    private Double unitPrice;
    private Double totalPrice;

    @Getter
    @Setter
    public static class MenuItemSummary {
        private Long id;
        private String name;
        private String image;
        private Double price;
        private Double discountPrice;
    }
}
