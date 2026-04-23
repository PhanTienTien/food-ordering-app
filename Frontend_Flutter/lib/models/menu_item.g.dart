// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemImpl _$$MenuItemImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      status: json['status'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      restaurantId: (json['restaurantId'] as num?)?.toInt(),
      restaurantName: json['restaurantName'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
    );

Map<String, dynamic> _$$MenuItemImplToJson(_$MenuItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'status': instance.status,
      'image': instance.image,
      'description': instance.description,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
    };
