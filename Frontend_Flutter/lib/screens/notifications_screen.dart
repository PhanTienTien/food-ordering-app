import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';
import '../utils/token_storage.dart';

class NotificationsScreen extends StatefulWidget {
  final int? userId;

  const NotificationsScreen({super.key, this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
      final userId = widget.userId ?? await TokenStorage.getUserId();
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
    }
  }

  Future<void> _markAllAsRead() async {
    final userId = widget.userId ?? await TokenStorage.getUserId();
    if (userId == null) return;
    await _service.markAllAsRead(userId);
    await _loadNotifications();
  }

  Future<void> _toggleRead(AppNotification item) async {
    final userId = widget.userId ?? await TokenStorage.getUserId();
    if (userId == null || item.id == null) return;
    if (item.isRead == true) return;
    await _service.markAsRead(item.id!, userId);
    await _loadNotifications();
  }

  Future<void> _delete(AppNotification item) async {
    if (item.id == null) return;
    await _service.deleteNotification(item.id!);
    await _loadNotifications();
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
