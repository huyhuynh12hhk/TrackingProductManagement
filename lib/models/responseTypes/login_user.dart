import 'package:json_annotation/json_annotation.dart';

part 'login_user.g.dart';

@JsonSerializable()
class LoginUser {
  final String id;
  final String token;
  final String fullName;
  final String email;
  final String avatarImage;
  final String backgroundImage;

  const LoginUser({
    required this.id,
    required this.token,
    required this.fullName,
    required this.email,
    required this.avatarImage,
    required this.backgroundImage,
  });

  factory LoginUser.empty() {
    return const LoginUser(
        id: "",
        token: "",
        fullName: "",
        email: "",
        avatarImage: "",
        backgroundImage: "");
  }

  factory LoginUser.fromJson(Map<String, dynamic> parsedJson) {
    return _$LoginUserFromJson(parsedJson);
  }

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);

  bool isEmpty() {
    return id.isEmpty && token.isEmpty;
  }
}
