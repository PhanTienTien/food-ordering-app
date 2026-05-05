package com.tientien.foodapp.notification.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class NotificationResponse {

    private Long id;

    // Flattened user info
    private Long userId;

    private String title;
    private String message;
    private String type;

    private Long referenceId;
    private String referenceType;
    private Boolean isRead;

    private String createdAt;
}
