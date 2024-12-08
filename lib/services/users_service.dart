import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/base_response.dart';
import 'package:tracking_app_v1/models/responseTypes/relationship_item.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/models/result_model.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';

Future<ResultModel<UserProfile>> getUserInfo(String id,
    {String token = ""}) async {

  final auth = (token.isNotEmpty
          ? {HttpHeaders.authorizationHeader: 'Bearer $token'}
          : {"": ""});

  var result = await http.get(
    Uri.parse("${ApiEndpoints.userProfile}/${id}"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      ...auth
    },
  );

  // print("Data body: ${result.body}");

  await Future.delayed(const Duration(seconds: 1));

  // return ResultModel.success(rs, 200);
  if (result.statusCode >= 200 && result.statusCode <= 299) {
    // print("Data: ${json.decode(result.body)}");
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response: ${data.data}");
    final profile = UserProfile.fromJson(data.data);
    print(
        "Profile of ${profile.fullName} at location ${profile.address.isEmpty ? "not set" : profile.address}");

    return ResultModel.success(profile, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}

Future<ResultModel<List<RelationshipItem>>> getUserRelationships(
    String id) async {
  print("Start to fetch relationships");
  final result = await http.get(
    Uri.parse("${ApiEndpoints.userRelationship}/${id}"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // await Future.delayed(const Duration(seconds: 1));

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    // print("Data: ${json.decode(result.body)}");
    final data = BaseResponse.fromJson(json.decode(result.body));

    Iterable items = data.data;
    List<RelationshipItem> results =
        List.from(items.map((item) => RelationshipItem.fromJson(item)));
    // print("Got ${results.length} item");

    return ResultModel.success(results, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}

Future<ResultModel<void>> addUserRelationships(
    String toUserId, String token) async {

  print("Start to add relationships");
  
  final result = await http.post(
    Uri.parse("${ApiEndpoints.userRelationship}/${toUserId}"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );

  // await Future.delayed(const Duration(seconds: 1));
  print("Request status: ${result.statusCode}");
  print("Raw body: ${result.body}");

  // return ResultModel.success(result, 200);
  if (result.statusCode >= 200 && result.statusCode <= 299) {
    // print("Data: ${json.decode(result.body)}");
    // final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response: ${data.data}");
    

    return ResultModel.success(null, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}
