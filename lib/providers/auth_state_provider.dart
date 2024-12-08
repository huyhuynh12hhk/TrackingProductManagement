// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
// import 'package:tracking_app_v1/providers/local_storage_provider.dart';
// import 'package:tracking_app_v1/services/account_service.dart';

// class AuthStateProvider extends ChangeNotifier {
//   LoginUser _user = LoginUser.empty();
//   bool _isAuthenticated = false;
//   bool displayedOnboard = false;
//   LocalStorage storage = LocalStorage.getInstance();

//   void setCurrentUser(LoginUser user) async {
//     _user = user;
//     await storage.savePersistingUser(user);
//     notifyListeners();
//   }

//   Future<void> logout() async {
//     // print("Old auth state: $_isAuthenticated");
//     _isAuthenticated = false;
//     _user = LoginUser.empty();
//     await storage.clearAll();
//     print("Logging out...");

//     notifyListeners();
//   }

//   bool get isAuthorized => _isAuthenticated;

//   Future<void> checkAuthState() async {
//     if (_user.isEmpty()) {
//       print("Try fetch user");

//       _user = await storage.getSavedUser() ?? _user;

//       if (!_user.isEmpty()) {
//         print(">>Track auth: Hello user ${_user.fullName}");
//         _isAuthenticated = true;
//       } else {
//         print("No user found, try login");
//         _isAuthenticated = false;
//         await logout();
//       }
//       await Future.delayed(Duration(seconds: 1));
//       print("Old auth state: $_isAuthenticated");
//       notifyListeners();
//     }
//   }

//   LoginUser? get currentUser => _user;
// }
