package com.tientien.foodapp.banner.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.banner.enums.BannerStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "banners")
@Getter
@Setter
public class Banner extends BaseEntity {

    @Column(nullable = false)
    private String title;

    private String description;

    @Column(nullable = false)
    private String imageUrl;

    @Column(nullable = false)
    private String targetUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BannerStatus status;

    private Integer displayOrder = 0;

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    private Integer clickCount = 0;
}
