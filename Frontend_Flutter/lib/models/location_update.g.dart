// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationUpdateImpl _$$LocationUpdateImplFromJson(Map<String, dynamic> json) =>
    _$LocationUpdateImpl(
      orderId: (json['orderId'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$$LocationUpdateImplToJson(
  _$LocationUpdateImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'status': instance.status,
  'timestamp': instance.timestamp,
};
