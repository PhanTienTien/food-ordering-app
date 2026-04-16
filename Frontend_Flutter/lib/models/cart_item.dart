import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    int? id,
    required int quantity,
    MenuItem? menuItem,
    double? unitPrice,
    double? totalPrice,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}
