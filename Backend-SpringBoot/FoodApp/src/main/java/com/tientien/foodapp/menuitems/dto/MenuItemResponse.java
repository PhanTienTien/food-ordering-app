package com.tientien.foodapp.menuitems.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MenuItemResponse {

    private Long id;
    private String name;
    private Double price;
    private Double discountPrice;
    private String status;
    private String image;
    private String description;

    // Flattened restaurant info
    private Long restaurantId;
    private String restaurantName;

    // Flattened category info
    private Long categoryId;
    private String categoryName;
}
