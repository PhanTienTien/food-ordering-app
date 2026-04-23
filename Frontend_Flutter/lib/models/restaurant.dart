import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    int? id,
    String? name,
    String? address,
    String? status,
    bool? isOpen,
    String? image,
    double? latitude,
    double? longitude,
    double? deliveryRadius,
    double? distanceKm,
    double? shippingFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
