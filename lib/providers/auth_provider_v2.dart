import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/providers/local_storage_provider.dart';
import 'package:tracking_app_v1/services/account_service.dart';

class AuthStateProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  LoginUser _user = LoginUser.empty();
  final _authStateController = StreamController<bool>.broadcast();
  final _localStorage = LocalStorage.getInstance();
  int _retryCount = 0;

  // Stream to expose auth state
  Stream<bool> get authStateStream => _authStateController.stream;

  LoginUser? get currentUser => _user;

  AuthStateProvider() {
    // logout();
    _checkInitialAuthState().whenComplete(
      () {
        // _listenToAuthChanges();
      },
    );
    // _listenToAuthChanges();
  }

  Future<void> _checkInitialAuthState() async {
    print("Check init auth state");
    // Check if token exists on startup
    try {
      String? token = await _localStorage.getToken();
      _user = await _localStorage.getSavedUser() ?? LoginUser.empty();
      _isAuthenticated = token.isNotEmpty && !_user.isEmpty();
      _authStateController.add(_isAuthenticated);
    } catch (e) {
      print(">>Auth init: Something went wrong");
      print(e);
      _isAuthenticated = false;
      _authStateController.add(_isAuthenticated);
    }
  }

  void _listenToAuthChanges() {
    if (!_user.isEmpty()) {
      print("Listen auth state");
      // Start listening to token changes
      // Example: if using shared_preferences, set a listener on token key changes
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        _retryCount++;
        String? token = await _localStorage.getToken();
        LoginUser user =
            await _localStorage.getSavedUser() ?? LoginUser.empty();

        bool isAuthenticated = token.isNotEmpty && !user.isEmpty();

        // Emit a new auth state if there's a change
        if (isAuthenticated != _isAuthenticated) {
          _isAuthenticated = isAuthenticated;
          _authStateController.add(_isAuthenticated);
        }
        if (_retryCount == 5) {
          print("It done!");
        }
      });
    } else {
      print("User is null");
    }
  }

  bool get isAuthorized {
    return !_user.isEmpty();
  }

  Future<void> login(String email, String password) async {
    print("Start login");
    // Assume successful login and save token
    // await localStorage.saveToken("some_token");
    var rs = await loginUser(email, password);
    print("Success state: ${rs.isSuccess}");
    if (rs.isSuccess) {
      _user = rs.data!;
    }
    _isAuthenticated = rs.isSuccess;
    _authStateController.add(_isAuthenticated);

    notifyListeners();
  }

  Future<void> logout() async {
    await _localStorage.clearAll();
    _isAuthenticated = false;
    _user = LoginUser.empty();
    _authStateController.add(_isAuthenticated);
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateController.close();
    super.dispose();
  }
}
