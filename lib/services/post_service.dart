import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/base_response.dart';
import 'package:tracking_app_v1/models/responseTypes/post.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/result_model.dart';

Future<ResultModel<List<Post>>> getFeedPosts(String token) async {
  // print("Start fetch post");

  var result = await http.get(
    Uri.parse("${ApiEndpoints.CRUDPost}"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );

  // print("Raw body: ${result.body}");

  // await Future.delayed(Duration(seconds: 3));

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response data: ${data.data}");

    
      Iterable items = data.data;
      List<Post> posts = List.from(items.map((item) => Post.fromJson(item)));

      // print("List post[0] from: ${posts[0].author.fullName}");

      return ResultModel.success(posts, result.statusCode);
    
  } else {
    // print("Fail");
    var errorBody = jsonDecode(result.body);
    String error = errorBody['message'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}
