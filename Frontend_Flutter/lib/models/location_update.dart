import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_update.freezed.dart';
part 'location_update.g.dart';

@freezed
class LocationUpdate with _$LocationUpdate {
  const factory LocationUpdate({
    int? orderId,
    double? latitude,
    double? longitude,
    String? status,
    String? timestamp,
  }) = _LocationUpdate;

  factory LocationUpdate.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateFromJson(json);
}
