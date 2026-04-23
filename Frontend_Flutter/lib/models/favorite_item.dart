import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item.dart';

part 'favorite_item.freezed.dart';
part 'favorite_item.g.dart';

@freezed
class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    int? id,
    MenuItem? menuItem,
    String? createdAt,
    String? updatedAt,
  }) = _FavoriteItem;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);
}
