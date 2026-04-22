package com.tientien.foodapp.shipper.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.common.enums.UserRole;
import com.tientien.foodapp.shipper.enums.ShipperStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "shippers")
@Getter
@Setter
public class Shipper extends BaseEntity {

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private String email;

    private String licensePlate;

    private String vehicleType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ShipperStatus status;

    private Double latitude;

    private Double longitude;

    private Boolean isAvailable = true;

    private Double rating;

    private Integer totalDeliveries = 0;
}
