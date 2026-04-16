import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    int? id,
    int? quantity,
    double? priceAtOrder,
    double? totalPrice,
    MenuItem? menuItem,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}
