package com.tientien.foodapp.address.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "addresses")
@Getter
@Setter
public class Address extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String fullName;

    @Column(nullable = false)
    private String phoneNumber;

    @Column(nullable = false)
    private String addressLine;

    private String city;
    private String district;
    private String ward;

    private Double latitude;
    private Double longitude;

    @Column(nullable = false)
    private Boolean isDefault = false;
}
