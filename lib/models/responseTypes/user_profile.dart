import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String avatarImage;
  final String backgroundImage;
  final String description;
  final String address;
  final String phoneNumber;
  final String gender;
  final String relationship;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarImage = "",
    this.backgroundImage = "",
    this.description = "",
    this.address = "",
    this.phoneNumber = "",
    this.gender = "",
    this.relationship = "",
  });

  // factory UserProfileModel.empty() {
  //   return const UserProfileModel(
  //       id: "", fullName: "", email: "", avatar: "", backgroundImage: "");
  // }

  factory UserProfile.fromJson(Map<String, dynamic> parsedJson) {
    return _$UserProfileFromJson(parsedJson);
  }

  factory UserProfile.cloneFrom(UserProfile user)=>UserProfile(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      avatarImage: user.avatarImage,
      backgroundImage: user.backgroundImage,
      description: user.description,
      address: user.address,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
    );

  factory UserProfile.fromCurrentUser(LoginUser currentUser) {
    return UserProfile(
        id: currentUser.id,
        fullName: currentUser.fullName,
        email: currentUser.email,
        avatarImage: currentUser.avatarImage,
        backgroundImage: currentUser.backgroundImage);
  }

  factory UserProfile.empty() {
    return const UserProfile(
        id: "",
        fullName: "",
        email: "",
        );
  }

  UserProfile expandInfo(
      {String gender = "",
      String description = "",
      String address = "",
      String phoneNumber = ""}) {
    return UserProfile(
        id: id,
        fullName: fullName,
        email: email,
        avatarImage: avatarImage,
        backgroundImage: backgroundImage,
        address: address,
        phoneNumber: phoneNumber,
        description: description,
        gender: gender);
  }

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  bool isEmpty() {
    return id.isEmpty;
  }
}
