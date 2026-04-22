import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'cart.freezed.dart';

part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    int? id,
    int? userId,
    int? restaurantId,
    String? restaurantName,
    @Default([]) List<CartItem> items,
    double? totalAmount,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
