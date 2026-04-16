package com.tientien.foodapp.cart.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "cart_items",
        uniqueConstraints = @UniqueConstraint(columnNames = {"cart_id", "menu_item_id"}))
@Getter
@Setter
public class CartItem extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "cart_id")
    private Cart cart;

    @ManyToOne
    @JoinColumn(name = "menu_item_id")
    private MenuItem menuItem;

    @Column(nullable = false)
    private Integer quantity;
}
