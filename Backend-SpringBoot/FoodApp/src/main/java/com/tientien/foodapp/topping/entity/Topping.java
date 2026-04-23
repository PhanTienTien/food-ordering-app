package com.tientien.foodapp.topping.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.topping.enums.ToppingStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "toppings")
@Getter
@Setter
public class Topping extends BaseEntity {

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private Double price;

    private String description;

    private String image;

    @Enumerated(EnumType.STRING)
    private ToppingStatus status;

    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
}
