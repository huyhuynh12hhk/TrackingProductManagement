import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final String id;
  final String content;
  final UserProfile author;
  final List<String>? attachmentPaths;
  final List<String>? likes;
  final String timeStamp;

  const Post(
      {required this.id,
      required this.content,
      required this.author,
      this.attachmentPaths,
      this.likes,
      this.timeStamp = ""});

  factory Post.fromJson(Map<String, dynamic> response) {
    return _$PostFromJson(response);
  }

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
