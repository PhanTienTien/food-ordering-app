import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    int? id,
    int? userId,
    String? fullName,
    String? phoneNumber,
    String? addressLine,
    String? city,
    String? district,
    String? ward,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? createdAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
