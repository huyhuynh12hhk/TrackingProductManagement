import 'dart:convert';

import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/base_response.dart';
import 'package:tracking_app_v1/models/responseTypes/search_result.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/models/result_model.dart';
import 'package:http/http.dart' as http;

Future<ResultModel<List<SearchResult>>> searchAll(String query) async {
  print("Start on searching '${query}'");
  await Future.delayed(const Duration(milliseconds: 100));
  var result = await http.get(
    Uri.parse("${ApiEndpoints.searchAll}?query=${query}"),
    headers: {
      // 'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // return ResultModel.success(rs, 200);
  if (result.statusCode >= 200 && result.statusCode <= 299) {
    // print("Data: ${json.decode(result.body)}");
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response data: ${data.data}");

    Iterable items = data.data;
    List<SearchResult> results =
        List.from(items.map((item) => SearchResult.fromJson(item)));

    return ResultModel.success(results, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}
