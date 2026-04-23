import 'package:freezed_annotation/freezed_annotation.dart';

part 'topping.freezed.dart';
part 'topping.g.dart';

@freezed
class Topping with _$Topping {
  const factory Topping({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? status,
    int? restaurantId,
    String? createdAt,
  }) = _Topping;

  factory Topping.fromJson(Map<String, dynamic> json) =>
      _$ToppingFromJson(json);
}
