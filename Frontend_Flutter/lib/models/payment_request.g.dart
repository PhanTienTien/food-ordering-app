// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentRequestImpl _$$PaymentRequestImplFromJson(Map<String, dynamic> json) =>
    _$PaymentRequestImpl(
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      simulateSuccess: json['simulateSuccess'] as bool? ?? true,
    );

Map<String, dynamic> _$$PaymentRequestImplToJson(
  _$PaymentRequestImpl instance,
) => <String, dynamic>{
  'paymentMethod': instance.paymentMethod,
  'transactionId': instance.transactionId,
  'simulateSuccess': instance.simulateSuccess,
};
