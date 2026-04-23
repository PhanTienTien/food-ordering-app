import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    int? id,
    String? code,
    String? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    String? startDate,
    String? endDate,
    int? usageLimit,
    int? usageCount,
    String? status,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}
