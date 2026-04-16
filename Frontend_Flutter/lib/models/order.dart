import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    int? id,
    int? userId,
    String? userName,
    int? restaurantId,
    String? restaurantName,
    String? status,
    double? totalPrice,
    double? finalPrice,
    DateTime? createdAt,
    @Default([]) List<OrderItem> items,
    // Payment fields
    String? paymentMethod,
    String? paymentStatus,
    String? shippingAddress,
    String? phoneNumber,
    String? note,
    double? shippingFee,
    double? discountAmount,
    String? voucherCode,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
