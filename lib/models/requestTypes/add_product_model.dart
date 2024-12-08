import 'package:json_annotation/json_annotation.dart';

part 'add_product_model.g.dart';

@JsonSerializable()
class AddProductModel {
  final String name;
  final String description;
  final double price;
  final double discount;
  final List<String> galleryPaths;
  final String supplierId;
  final Map<String, String> originKeys;
  final bool isNotify;

  AddProductModel(
    {
    required this.name,
    this.description = "",
    required this.price,
    this.discount = 0,
    required this.galleryPaths,
    required this.supplierId,
    required this.originKeys,
    this.isNotify = false, 
  });

  factory AddProductModel.fromJson(Map<String, dynamic> response) {
    return _$AddProductModelFromJson(response);
  }

  Map<String, dynamic> toJson() => _$AddProductModelToJson(this);
}
