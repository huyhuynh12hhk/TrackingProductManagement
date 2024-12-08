import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final String avatarImage;
  final UserProfile supplier;
  final List<String>? galleryPaths;
  final List<Product>? originProducts;

  Product({
    required this.supplier,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originProducts,
    this.galleryPaths,
    this.avatarImage = "",
    this.discount = 0,
  });

  factory Product.empty() {
    return Product(
        id: "",
        name: "",
        description: "",
        price: 0,
        supplier: UserProfile.empty());
  }

  factory Product.cloneFrom(Product product) => Product(
        supplier: UserProfile.cloneFrom(product.supplier),
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        galleryPaths: product.galleryPaths,
        avatarImage: product.avatarImage,
        discount: product.discount,
        
      );

  factory Product.fromJson(Map<String, dynamic> response) {
    return _$ProductFromJson(response);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // List<String> get galleryItems => galleries.split(',');
  // void addToGallery(String image){
  //   galleryItems.add(image);
  //   galleries = galleryItems.join(',');
  // }
}
