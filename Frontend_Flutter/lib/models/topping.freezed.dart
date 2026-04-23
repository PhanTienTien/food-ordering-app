// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topping.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Topping _$ToppingFromJson(Map<String, dynamic> json) {
  return _Topping.fromJson(json);
}

/// @nodoc
mixin _$Topping {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get restaurantId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Topping to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Topping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToppingCopyWith<Topping> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToppingCopyWith<$Res> {
  factory $ToppingCopyWith(Topping value, $Res Function(Topping) then) =
      _$ToppingCopyWithImpl<$Res, Topping>;
  @useResult
  $Res call({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? status,
    int? restaurantId,
    String? createdAt,
  });
}

/// @nodoc
class _$ToppingCopyWithImpl<$Res, $Val extends Topping>
    implements $ToppingCopyWith<$Res> {
  _$ToppingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Topping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? description = freezed,
    Object? image = freezed,
    Object? status = freezed,
    Object? restaurantId = freezed,
    Object? createdAt = freezed,
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
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            restaurantId: freezed == restaurantId
                ? _value.restaurantId
                : restaurantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToppingImplCopyWith<$Res> implements $ToppingCopyWith<$Res> {
  factory _$$ToppingImplCopyWith(
    _$ToppingImpl value,
    $Res Function(_$ToppingImpl) then,
  ) = __$$ToppingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? status,
    int? restaurantId,
    String? createdAt,
  });
}

/// @nodoc
class __$$ToppingImplCopyWithImpl<$Res>
    extends _$ToppingCopyWithImpl<$Res, _$ToppingImpl>
    implements _$$ToppingImplCopyWith<$Res> {
  __$$ToppingImplCopyWithImpl(
    _$ToppingImpl _value,
    $Res Function(_$ToppingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Topping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? description = freezed,
    Object? image = freezed,
    Object? status = freezed,
    Object? restaurantId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ToppingImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        restaurantId: freezed == restaurantId
            ? _value.restaurantId
            : restaurantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ToppingImpl implements _Topping {
  const _$ToppingImpl({
    this.id,
    this.name,
    this.price,
    this.description,
    this.image,
    this.status,
    this.restaurantId,
    this.createdAt,
  });

  factory _$ToppingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToppingImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final double? price;
  @override
  final String? description;
  @override
  final String? image;
  @override
  final String? status;
  @override
  final int? restaurantId;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'Topping(id: $id, name: $name, price: $price, description: $description, image: $image, status: $status, restaurantId: $restaurantId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToppingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    description,
    image,
    status,
    restaurantId,
    createdAt,
  );

  /// Create a copy of Topping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToppingImplCopyWith<_$ToppingImpl> get copyWith =>
      __$$ToppingImplCopyWithImpl<_$ToppingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToppingImplToJson(this);
  }
}

abstract class _Topping implements Topping {
  const factory _Topping({
    final int? id,
    final String? name,
    final double? price,
    final String? description,
    final String? image,
    final String? status,
    final int? restaurantId,
    final String? createdAt,
  }) = _$ToppingImpl;

  factory _Topping.fromJson(Map<String, dynamic> json) = _$ToppingImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  double? get price;
  @override
  String? get description;
  @override
  String? get image;
  @override
  String? get status;
  @override
  int? get restaurantId;
  @override
  String? get createdAt;

  /// Create a copy of Topping
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToppingImplCopyWith<_$ToppingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
