package com.tientien.foodapp.category.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "categories")
@Getter
@Setter
public class Category extends BaseEntity {

    @Column(nullable = false)
    private String name;

    private String image;

    @ManyToOne
    private Restaurant restaurant;
}
