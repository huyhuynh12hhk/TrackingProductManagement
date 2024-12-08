// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      supplier: UserProfile.fromJson(json['supplier'] as Map<String, dynamic>),
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originProducts: (json['originProducts'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      galleryPaths: (json['galleryPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      avatarImage: json['avatarImage'] as String? ?? "",
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'discount': instance.discount,
      'avatarImage': instance.avatarImage,
      'supplier': instance.supplier,
      'galleryPaths': instance.galleryPaths,
      'originProducts': instance.originProducts,
    };
