// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToppingImpl _$$ToppingImplFromJson(Map<String, dynamic> json) =>
    _$ToppingImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
      restaurantId: (json['restaurantId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$ToppingImplToJson(_$ToppingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'image': instance.image,
      'status': instance.status,
      'restaurantId': instance.restaurantId,
      'createdAt': instance.createdAt,
    };
