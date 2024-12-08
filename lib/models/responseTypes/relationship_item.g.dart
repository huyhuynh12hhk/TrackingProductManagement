// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationshipItem _$RelationshipItemFromJson(Map<String, dynamic> json) =>
    RelationshipItem(
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$RelationshipItemToJson(RelationshipItem instance) =>
    <String, dynamic>{
      'user': instance.user,
      'type': instance.type,
    };
