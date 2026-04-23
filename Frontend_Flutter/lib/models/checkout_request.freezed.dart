// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutRequest _$CheckoutRequestFromJson(Map<String, dynamic> json) {
  return _CheckoutRequest.fromJson(json);
}

/// @nodoc
mixin _$CheckoutRequest {
  int get userId => throw _privateConstructorUsedError;
  String get shippingAddress => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get paymentMethod =>
      throw _privateConstructorUsedError; // COD, VNPAY, MOMO, CARD
  String? get voucherCode => throw _privateConstructorUsedError;

  /// Serializes this CheckoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutRequestCopyWith<CheckoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutRequestCopyWith<$Res> {
  factory $CheckoutRequestCopyWith(
    CheckoutRequest value,
    $Res Function(CheckoutRequest) then,
  ) = _$CheckoutRequestCopyWithImpl<$Res, CheckoutRequest>;
  @useResult
  $Res call({
    int userId,
    String shippingAddress,
    String phoneNumber,
    String? note,
    String? paymentMethod,
    String? voucherCode,
  });
}

/// @nodoc
class _$CheckoutRequestCopyWithImpl<$Res, $Val extends CheckoutRequest>
    implements $CheckoutRequestCopyWith<$Res> {
  _$CheckoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? shippingAddress = null,
    Object? phoneNumber = null,
    Object? note = freezed,
    Object? paymentMethod = freezed,
    Object? voucherCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            shippingAddress: null == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            voucherCode: freezed == voucherCode
                ? _value.voucherCode
                : voucherCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckoutRequestImplCopyWith<$Res>
    implements $CheckoutRequestCopyWith<$Res> {
  factory _$$CheckoutRequestImplCopyWith(
    _$CheckoutRequestImpl value,
    $Res Function(_$CheckoutRequestImpl) then,
  ) = __$$CheckoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userId,
    String shippingAddress,
    String phoneNumber,
    String? note,
    String? paymentMethod,
    String? voucherCode,
  });
}

/// @nodoc
class __$$CheckoutRequestImplCopyWithImpl<$Res>
    extends _$CheckoutRequestCopyWithImpl<$Res, _$CheckoutRequestImpl>
    implements _$$CheckoutRequestImplCopyWith<$Res> {
  __$$CheckoutRequestImplCopyWithImpl(
    _$CheckoutRequestImpl _value,
    $Res Function(_$CheckoutRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? shippingAddress = null,
    Object? phoneNumber = null,
    Object? note = freezed,
    Object? paymentMethod = freezed,
    Object? voucherCode = freezed,
  }) {
    return _then(
      _$CheckoutRequestImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        shippingAddress: null == shippingAddress
            ? _value.shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        voucherCode: freezed == voucherCode
            ? _value.voucherCode
            : voucherCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutRequestImpl implements _CheckoutRequest {
  const _$CheckoutRequestImpl({
    required this.userId,
    required this.shippingAddress,
    required this.phoneNumber,
    this.note,
    this.paymentMethod,
    this.voucherCode,
  });

  factory _$CheckoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutRequestImplFromJson(json);

  @override
  final int userId;
  @override
  final String shippingAddress;
  @override
  final String phoneNumber;
  @override
  final String? note;
  @override
  final String? paymentMethod;
  // COD, VNPAY, MOMO, CARD
  @override
  final String? voucherCode;

  @override
  String toString() {
    return 'CheckoutRequest(userId: $userId, shippingAddress: $shippingAddress, phoneNumber: $phoneNumber, note: $note, paymentMethod: $paymentMethod, voucherCode: $voucherCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.voucherCode, voucherCode) ||
                other.voucherCode == voucherCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    shippingAddress,
    phoneNumber,
    note,
    paymentMethod,
    voucherCode,
  );

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutRequestImplCopyWith<_$CheckoutRequestImpl> get copyWith =>
      __$$CheckoutRequestImplCopyWithImpl<_$CheckoutRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutRequestImplToJson(this);
  }
}

abstract class _CheckoutRequest implements CheckoutRequest {
  const factory _CheckoutRequest({
    required final int userId,
    required final String shippingAddress,
    required final String phoneNumber,
    final String? note,
    final String? paymentMethod,
    final String? voucherCode,
  }) = _$CheckoutRequestImpl;

  factory _CheckoutRequest.fromJson(Map<String, dynamic> json) =
      _$CheckoutRequestImpl.fromJson;

  @override
  int get userId;
  @override
  String get shippingAddress;
  @override
  String get phoneNumber;
  @override
  String? get note;
  @override
  String? get paymentMethod; // COD, VNPAY, MOMO, CARD
  @override
  String? get voucherCode;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutRequestImplCopyWith<_$CheckoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
