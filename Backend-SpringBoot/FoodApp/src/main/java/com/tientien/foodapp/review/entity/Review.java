package com.tientien.foodapp.review.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "reviews")
@Getter
@Setter
public class Review extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;

    private Integer rating;
    private String comment;
}