import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_request.freezed.dart';
part 'checkout_request.g.dart';

@freezed
class CheckoutRequest with _$CheckoutRequest {
  const factory CheckoutRequest({
    required int userId,
    required String shippingAddress,
    required String phoneNumber,
    String? note,
    String? paymentMethod, // COD, VNPAY, MOMO, CARD
    String? voucherCode,
  }) = _CheckoutRequest;

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestFromJson(json);
}
