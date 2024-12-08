// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) => LoginUser(
      id: json['id'] as String,
      token: json['token'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      avatarImage: json['avatarImage'] as String,
      backgroundImage: json['backgroundImage'] as String,
    );

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'fullName': instance.fullName,
      'email': instance.email,
      'avatarImage': instance.avatarImage,
      'backgroundImage': instance.backgroundImage,
    };
