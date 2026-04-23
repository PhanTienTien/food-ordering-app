// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutRequestImpl _$$CheckoutRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutRequestImpl(
  userId: (json['userId'] as num).toInt(),
  shippingAddress: json['shippingAddress'] as String,
  phoneNumber: json['phoneNumber'] as String,
  note: json['note'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  voucherCode: json['voucherCode'] as String?,
);

Map<String, dynamic> _$$CheckoutRequestImplToJson(
  _$CheckoutRequestImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'shippingAddress': instance.shippingAddress,
  'phoneNumber': instance.phoneNumber,
  'note': instance.note,
  'paymentMethod': instance.paymentMethod,
  'voucherCode': instance.voucherCode,
};
