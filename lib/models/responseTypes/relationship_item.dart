import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';

part 'relationship_item.g.dart';

@JsonSerializable()
class RelationshipItem {
  final UserProfile user;
  final String type;

  const RelationshipItem({
    required this.user,
    required this.type,
  });

  factory RelationshipItem.fromJson(Map<String, dynamic> json) =>
      _$RelationshipItemFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipItemToJson(this);
}
