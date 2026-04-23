// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  restaurantId: (json['restaurantId'] as num?)?.toInt(),
  restaurantName: json['restaurantName'] as String?,
  status: json['status'] as String?,
  totalPrice: (json['totalPrice'] as num?)?.toDouble(),
  finalPrice: (json['finalPrice'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  paymentMethod: json['paymentMethod'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  shippingAddress: json['shippingAddress'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  note: json['note'] as String?,
  shippingFee: (json['shippingFee'] as num?)?.toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble(),
  voucherCode: json['voucherCode'] as String?,
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'finalPrice': instance.finalPrice,
      'createdAt': instance.createdAt?.toIso8601String(),
      'items': instance.items,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'shippingAddress': instance.shippingAddress,
      'phoneNumber': instance.phoneNumber,
      'note': instance.note,
      'shippingFee': instance.shippingFee,
      'discountAmount': instance.discountAmount,
      'voucherCode': instance.voucherCode,
    };
