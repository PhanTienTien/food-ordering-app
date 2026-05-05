package com.tientien.foodapp.order.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderItemResponse {

    private Long id;
    private Integer quantity;
    private Double priceAtOrder;
    private Double totalPrice;

    // Nested menuItem info
    private MenuItemSummary menuItem;

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
