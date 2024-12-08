// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      content: json['content'] as String,
      author: UserProfile.fromJson(json['author'] as Map<String, dynamic>),
      attachmentPaths: (json['attachmentPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      timeStamp: json['timeStamp'] as String? ?? "",
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'attachmentPaths': instance.attachmentPaths,
      'likes': instance.likes,
      'timeStamp': instance.timeStamp,
    };
