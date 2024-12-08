class RegisterModel {
  final String email;
  final String fullName;
  final String password;
  final String phoneNumber;

  const RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
    };
  }
}
