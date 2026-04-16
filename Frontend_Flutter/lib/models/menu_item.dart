import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    int? id,
    required String name,
    required double price,
    double? discountPrice,
    String? status,
    String? image,
    String? description,
    int? restaurantId,
    String? restaurantName,
    int? categoryId,
    String? categoryName,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);
}
