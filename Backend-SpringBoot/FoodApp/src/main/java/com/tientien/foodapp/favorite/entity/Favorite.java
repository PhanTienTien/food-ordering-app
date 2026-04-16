package com.tientien.foodapp.favorite.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "favorites")
@Getter
@Setter
public class Favorite extends BaseEntity {

    @ManyToOne
    private User user;

    @ManyToOne
    private MenuItem menuItem;
}
