// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      avatarImage: json['avatarImage'] as String? ?? "",
      backgroundImage: json['backgroundImage'] as String? ?? "",
      description: json['description'] as String? ?? "",
      address: json['address'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String? ?? "",
      gender: json['gender'] as String? ?? "",
      relationship: json['relationship'] as String? ?? "",
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'avatarImage': instance.avatarImage,
      'backgroundImage': instance.backgroundImage,
      'description': instance.description,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'gender': instance.gender,
      'relationship': instance.relationship,
    };
