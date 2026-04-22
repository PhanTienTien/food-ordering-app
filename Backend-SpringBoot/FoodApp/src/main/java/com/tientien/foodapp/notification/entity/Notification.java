package com.tientien.foodapp.notification.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.notification.enums.NotificationType;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "notifications")
@Getter
@Setter
public class Notification extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NotificationType type;

    private Long referenceId; // order_id, restaurant_id, etc.

    private String referenceType;

    @Column(nullable = false)
    private Boolean isRead = false;
}
