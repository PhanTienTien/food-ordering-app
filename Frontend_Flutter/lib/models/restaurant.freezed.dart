// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return _Restaurant.fromJson(json);
}

/// @nodoc
mixin _$Restaurant {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  bool? get isOpen => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get deliveryRadius => throw _privateConstructorUsedError;
  double? get commissionRate => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  double? get shippingFee => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Restaurant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantCopyWith<Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantCopyWith<$Res> {
  factory $RestaurantCopyWith(
    Restaurant value,
    $Res Function(Restaurant) then,
  ) = _$RestaurantCopyWithImpl<$Res, Restaurant>;
  @useResult
  $Res call({
    int? id,
    String? name,
    String? address,
    String? status,
    bool? isOpen,
    String? image,
    String? phone,
    String? description,
    double? latitude,
    double? longitude,
    double? deliveryRadius,
    double? commissionRate,
    double? distanceKm,
    double? shippingFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$RestaurantCopyWithImpl<$Res, $Val extends Restaurant>
    implements $RestaurantCopyWith<$Res> {
  _$RestaurantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? status = freezed,
    Object? isOpen = freezed,
    Object? image = freezed,
    Object? phone = freezed,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? deliveryRadius = freezed,
    Object? commissionRate = freezed,
    Object? distanceKm = freezed,
    Object? shippingFee = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOpen: freezed == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryRadius: freezed == deliveryRadius
                ? _value.deliveryRadius
                : deliveryRadius // ignore: cast_nullable_to_non_nullable
                      as double?,
            commissionRate: freezed == commissionRate
                ? _value.commissionRate
                : commissionRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            shippingFee: freezed == shippingFee
                ? _value.shippingFee
                : shippingFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestaurantImplCopyWith<$Res>
    implements $RestaurantCopyWith<$Res> {
  factory _$$RestaurantImplCopyWith(
    _$RestaurantImpl value,
    $Res Function(_$RestaurantImpl) then,
  ) = __$$RestaurantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    String? address,
    String? status,
    bool? isOpen,
    String? image,
    String? phone,
    String? description,
    double? latitude,
    double? longitude,
    double? deliveryRadius,
    double? commissionRate,
    double? distanceKm,
    double? shippingFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RestaurantImplCopyWithImpl<$Res>
    extends _$RestaurantCopyWithImpl<$Res, _$RestaurantImpl>
    implements _$$RestaurantImplCopyWith<$Res> {
  __$$RestaurantImplCopyWithImpl(
    _$RestaurantImpl _value,
    $Res Function(_$RestaurantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? status = freezed,
    Object? isOpen = freezed,
    Object? image = freezed,
    Object? phone = freezed,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? deliveryRadius = freezed,
    Object? commissionRate = freezed,
    Object? distanceKm = freezed,
    Object? shippingFee = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RestaurantImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOpen: freezed == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryRadius: freezed == deliveryRadius
            ? _value.deliveryRadius
            : deliveryRadius // ignore: cast_nullable_to_non_nullable
                  as double?,
        commissionRate: freezed == commissionRate
            ? _value.commissionRate
            : commissionRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        shippingFee: freezed == shippingFee
            ? _value.shippingFee
            : shippingFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantImpl implements _Restaurant {
  const _$RestaurantImpl({
    this.id,
    this.name,
    this.address,
    this.status,
    this.isOpen,
    this.image,
    this.phone,
    this.description,
    this.latitude,
    this.longitude,
    this.deliveryRadius,
    this.commissionRate,
    this.distanceKm,
    this.shippingFee,
    this.createdAt,
    this.updatedAt,
  });

  factory _$RestaurantImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? address;
  @override
  final String? status;
  @override
  final bool? isOpen;
  @override
  final String? image;
  @override
  final String? phone;
  @override
  final String? description;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? deliveryRadius;
  @override
  final double? commissionRate;
  @override
  final double? distanceKm;
  @override
  final double? shippingFee;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, address: $address, status: $status, isOpen: $isOpen, image: $image, phone: $phone, description: $description, latitude: $latitude, longitude: $longitude, deliveryRadius: $deliveryRadius, commissionRate: $commissionRate, distanceKm: $distanceKm, shippingFee: $shippingFee, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.deliveryRadius, deliveryRadius) ||
                other.deliveryRadius == deliveryRadius) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    status,
    isOpen,
    image,
    phone,
    description,
    latitude,
    longitude,
    deliveryRadius,
    commissionRate,
    distanceKm,
    shippingFee,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      __$$RestaurantImplCopyWithImpl<_$RestaurantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantImplToJson(this);
  }
}

abstract class _Restaurant implements Restaurant {
  const factory _Restaurant({
    final int? id,
    final String? name,
    final String? address,
    final String? status,
    final bool? isOpen,
    final String? image,
    final String? phone,
    final String? description,
    final double? latitude,
    final double? longitude,
    final double? deliveryRadius,
    final double? commissionRate,
    final double? distanceKm,
    final double? shippingFee,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$RestaurantImpl;

  factory _Restaurant.fromJson(Map<String, dynamic> json) =
      _$RestaurantImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get address;
  @override
  String? get status;
  @override
  bool? get isOpen;
  @override
  String? get image;
  @override
  String? get phone;
  @override
  String? get description;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get deliveryRadius;
  @override
  double? get commissionRate;
  @override
  double? get distanceKm;
  @override
  double? get shippingFee;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
