package com.tientien.foodapp.menuitems.entity;

import com.tientien.foodapp.category.entity.Category;
import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "menu_items")
@Getter
@Setter
public class MenuItem extends BaseEntity {

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private Double price;

    private Double discountPrice;

    @Enumerated(EnumType.STRING)
    private MenuItemStatus status;

    private String image;

    private String description;

    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
}
