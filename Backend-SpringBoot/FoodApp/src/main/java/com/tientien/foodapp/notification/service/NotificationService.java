package com.tientien.foodapp.notification.service;

import com.tientien.foodapp.notification.entity.Notification;

import java.util.List;

public interface NotificationService {
    List<Notification> getNotificationsByUser(Long userId);
    List<Notification> getUnreadNotifications(Long userId);
    Long getUnreadCount(Long userId);
    Notification createNotification(Long userId, String title, String message, String type, Long referenceId, String referenceType);
    Notification markAsRead(Long notificationId, Long userId);
    void markAllAsRead(Long userId);
    void deleteNotification(Long notificationId);
}
