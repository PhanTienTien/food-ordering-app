package com.tientien.foodapp.restaurant.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.List;


@Entity
@Table(name = "restaurants")
@Getter
@Setter
public class Restaurant extends BaseEntity {

    private String name;
    private String address;

    private String status;

    @Column(name = "is_open")
    private Boolean isOpen;

    @OneToMany(mappedBy = "restaurant")
    @JsonIgnore
    private List<MenuItem> menuItems;

    // GPS coordinates
    private Double latitude;
    private Double longitude;

    // Delivery radius in kilometers
    private Double deliveryRadius = 10.0;
}
