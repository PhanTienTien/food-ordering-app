// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoucherImpl _$$VoucherImplFromJson(Map<String, dynamic> json) =>
    _$VoucherImpl(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      discountType: json['discountType'] as String?,
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
      maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      usageLimit: (json['usageLimit'] as num?)?.toInt(),
      usageCount: (json['usageCount'] as num?)?.toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$VoucherImplToJson(_$VoucherImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'minOrderAmount': instance.minOrderAmount,
      'maxDiscountAmount': instance.maxDiscountAmount,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'usageLimit': instance.usageLimit,
      'usageCount': instance.usageCount,
      'status': instance.status,
    };
