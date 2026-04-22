package com.tientien.foodapp.topping.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "menu_item_toppings",
        uniqueConstraints = @UniqueConstraint(columnNames = {"menu_item_id", "topping_id"}))
@Getter
@Setter
public class MenuItemTopping extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "menu_item_id")
    private MenuItem menuItem;

    @ManyToOne
    @JoinColumn(name = "topping_id")
    private Topping topping;
}
