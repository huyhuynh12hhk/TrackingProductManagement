import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';

class LocalStorage extends ChangeNotifier {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage.getInstance() => _instance;

  LocalStorage._internal();

  // AndroidOptions _getAndroidOptions() => const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     );

  FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  final Map<String, String> _all = {};

  Future<void> setToken(String token) async {
    await storage.write(key: "token", value: token);
    final decodedToken = JwtDecoder.decode(token);
    await storage.write(key: "tokenData", value: json.encode(decodedToken));

    await refetchData();
  }

  Future<void> savePersistingUser(LoginUser user) async {
    // print(">>Track user: ${json.encode(user)}");
    await storage.write(key: "user", value: json.encode(user.toJson()));
    print("User has saved to local storage");
    await refetchData();
  }

  Future<void> refetchData() async {
    var allVal = await storage.readAll();

    _all.clear();
    _all.addAll(allVal);

    // print(allVal);
    notifyListeners();
  }

  Future<String> getToken() async {
    return await storage.read(key: "token") ?? "";
  }

  Future<LoginUser?> getSavedUser() async {
    String? data = await storage.read(key: "user");

    if (data!.isNotEmpty) {
      return LoginUser.fromJson(json.decode(data!));
    }
    print(">>>Local: gone here");

    return null;
  }

  Future<void> clearAll() async {
    await storage.deleteAll();
    notifyListeners();
  }
}
