import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    int? id,
    int? userId,
    String? title,
    String? message,
    String? type,
    int? referenceId,
    String? referenceType,
    bool? isRead,
    String? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
