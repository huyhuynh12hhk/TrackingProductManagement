import 'dart:convert';

import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_app_v1/models/login_model.dart';
import 'package:tracking_app_v1/models/register_model.dart';
import 'package:tracking_app_v1/models/responseTypes/base_response.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/models/result_model.dart';
import 'package:tracking_app_v1/providers/local_storage_provider.dart';

final storage = LocalStorage.getInstance();

Future<ResultModel<void>> registUser(
    String name,
    String email, String password, 
    // String phoneNumber
  ) async {
  final registerData = RegisterModel(
    email: email,
    password: password,
    fullName: name,
  );

  // print("Start to post register form data: ${registerData.toJson()}");

  var result = await http.post(
    Uri.parse(ApiEndpoints.register),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(registerData.toJson()),
  );


  // print("Got Result ${result.statusCode}");
  // print("Message: ${result.body}");
  if (result.statusCode >= 200 && result.statusCode <= 299) {
    return ResultModel.success(null, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}

// Future<BaseResponse> loginUser(
// Future<ResponseModel<Map<String,dynamic>>> loginUser(
Future<ResultModel<LoginUser>> loginUser(
    String email, String password) async {
  // print("Start logging in....");
  final loginData = LoginModel(
    email: email,
    password: password,
  );

  var result = await http.post(
    Uri.parse(ApiEndpoints.login),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(loginData.toJson()),
  );

  print("Result: ${result.body}");
  // print(result.body);

  // return BaseResponse.fromJson(json.decode(result.body));

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("data success: ");
    // print(json.decode(result.body));

    final loginUser = LoginUser.fromJson(data.data);

    // print("Hello user ${loginUser.fullName}");

    // TokenHandler().addToken(loginUser.token);
    storage
    ..clearAll()
    ..setToken(loginUser.token)
    ..savePersistingUser(loginUser);



    // final decodedToken = JwtDecoder.decode(TokenHandler().getToken());
    return ResultModel.success(loginUser, result.statusCode);
    // return loginUser;
  } else {
    // print("Fail");
    var errorBody = jsonDecode(result.body);
    String error = errorBody['message'] ?? "An error occurred.";
    // return LoginUser(id: "", token: "token", fullName: "fullName", email: email, avatar: "avatar", backgroundImage: "backgroundImage");
    return ResultModel.fail(error, result.statusCode);
  }
}
