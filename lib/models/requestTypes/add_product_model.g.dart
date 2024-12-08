// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductModel _$AddProductModelFromJson(Map<String, dynamic> json) =>
    AddProductModel(
      name: json['name'] as String,
      description: json['description'] as String? ?? "",
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      galleryPaths: (json['galleryPaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      supplierId: json['supplierId'] as String,
      originKeys: Map<String, String>.from(json['originKeys'] as Map),
      isNotify: json['isNotify'] as bool? ?? false,
    );

Map<String, dynamic> _$AddProductModelToJson(AddProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'discount': instance.discount,
      'galleryPaths': instance.galleryPaths,
      'supplierId': instance.supplierId,
      'originKeys': instance.originKeys,
      'isNotify': instance.isNotify,
    };
