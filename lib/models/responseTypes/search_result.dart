import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/pages/account/user_profile_page.dart';
import 'package:tracking_app_v1/pages/common/not_found.dart';
import 'package:tracking_app_v1/pages/products/product_detail_page.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final String key;
  final String label;
  final String type;
  final String imagePath;

  const SearchResult({
    required this.key,
    required this.label,
    required this.type,
    required this.imagePath,
  });

  factory SearchResult.fromJson(Map<String, dynamic> response) {
    return _$SearchResultFromJson(response);
  }

  Widget navigateTo(){
    switch (type) {
      case "product":
        return ProductDetailPage(productId: key);
      case "user":
        return UserProfilePage(userProfile: UserProfile(id: key, fullName: label, email: "", avatarImage: imagePath));
      default:
        return NotFound();
    }
  }

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
