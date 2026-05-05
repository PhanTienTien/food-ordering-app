import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  final int? userId;

  const NotificationsScreen({super.key, this.userId});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final NotificationService _service = NotificationService();
  List<AppNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final userId = widget.userId ?? ref.read(authProvider).userId;
      if (userId == null) {
        throw Exception('Missing user id');
      }
      final loaded = await _service.getNotificationsByUser(userId);
      setState(() {
        notifications = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải thông báo: $e')),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final userId = widget.userId ?? ref.read(authProvider).userId;
    if (userId == null) return;
    try {
      await _service.markAllAsRead(userId);
      // Refresh unread count in provider
      await ref.read(notificationProvider.notifier).loadUnreadCount(userId);
      await _loadNotifications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thao tác thất bại: $e')),
        );
      }
    }
  }

  Future<void> _toggleRead(AppNotification item) async {
    final userId = widget.userId ?? ref.read(authProvider).userId;
    if (userId == null || item.id == null) return;
    if (item.isRead == true) return;
    try {
      await _service.markAsRead(item.id!, userId);
      // Refresh unread count in provider
      await ref.read(notificationProvider.notifier).loadUnreadCount(userId);
      await _loadNotifications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đánh dấu đã đọc thất bại: $e')),
        );
      }
    }
  }

  Future<void> _delete(AppNotification item) async {
    if (item.id == null) return;
    try {
      await _service.deleteNotification(item.id!);
      // Refresh unread count in provider
      final userId = widget.userId ?? ref.read(authProvider).userId;
      if (userId != null) {
        await ref.read(notificationProvider.notifier).loadUnreadCount(userId);
      }
      await _loadNotifications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thông báo thất bại: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Thông báo', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(onPressed: _markAllAsRead, child: const Text('Đọc hết')),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(child: Text('Không có thông báo'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  child: ListTile(
                    onTap: () => _toggleRead(item),
                    leading: Icon(
                      item.isRead == true
                          ? Icons.mark_email_read
                          : Icons.notifications,
                      color: item.isRead == true
                          ? Colors.grey
                          : AppColors.primary,
                    ),
                    title: Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontWeight: item.isRead == true
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item.message ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(item),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
