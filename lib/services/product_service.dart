import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/requestTypes/add_product_model.dart';
import 'package:tracking_app_v1/models/responseTypes/base_response.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/models/result_model.dart';

Future<ResultModel<Product>> fetchProductDetail(String id) async {

  print("On fetch product (${id})");

  var result =
      await http.get(
        Uri.parse("${ApiEndpoints.CRUDProduct}/${id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );

  print("Raw response: ${result.body}");
  // await Future.delayed(const Duration(seconds: 3));

  // return ResultModel.success(result, 200);
  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final response = BaseResponse.fromJson(json.decode(result.body));
    final product = Product.fromJson(response.data); 
    return ResultModel.success(product, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}



Future<ResultModel<List<Product>>> getProductsBySupplier(
    String supplierId) async {
  // print("Start fetch product");

  var result = await http.get(
    Uri.parse("${ApiEndpoints.getProductBySupplier}/${supplierId}"),
    // headers: {
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
  );

  // print("Result");
  // print(result.body);
  
  // await Future.delayed(Duration(seconds: 3));

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response data: ${data.data}");

    Iterable items = data.data;
    List<Product> products =
        List.from(items.map((item) => Product.fromJson(item)));

    // print("List product[0]: ${products[0].name}");

    return ResultModel.success(products, result.statusCode);
  } else {
    // print("Fail");
    var errorBody = jsonDecode(result.body);
    String error = errorBody['message'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}

Future<ResultModel<List<Product>>> searchProducts(
    String searchTerm) async {
  // print("Start search product");

  await Future.delayed(Duration(seconds: 1));

  var result = await http.get(
    Uri.parse("${ApiEndpoints.CRUDProduct}/?query=${searchTerm}"),
  );

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response data: ${data.data}");

    Iterable items = data.data;
    List<Product> products =
        List.from(items.map((item) => Product.fromJson(item)));

    // print("List product[0]: ${products[0].name}");

    return ResultModel.success(products, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['message'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}



Future<ResultModel<void>> addProduct(AddProductModel product) async {
  // print("Start to add product");
  
  var result = await http.post(
    Uri.parse(ApiEndpoints.CRUDProduct),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(product.toJson()),
  );

  // print("After add product Result: ${result.body}");

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    final data = BaseResponse.fromJson(json.decode(result.body));
    // print("Base response data: ${data.data}");

    return ResultModel.success(null, result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['message'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}
