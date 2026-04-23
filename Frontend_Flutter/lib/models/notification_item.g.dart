// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  title: json['title'] as String?,
  message: json['message'] as String?,
  type: json['type'] as String?,
  referenceId: (json['referenceId'] as num?)?.toInt(),
  referenceType: json['referenceType'] as String?,
  isRead: json['isRead'] as bool?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'type': instance.type,
  'referenceId': instance.referenceId,
  'referenceType': instance.referenceType,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt,
};
