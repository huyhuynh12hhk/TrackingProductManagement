


// https://stackoverflow.com/questions/61927993/how-to-return-the-data-in-multipartrequest-in-flutter
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/result_model.dart';
import 'package:path/path.dart';

Future<ResultModel<String>> saveMediaFile({required String authorId, required File file, String path = ""}) async{
  final filename = file.path.split('/').last;
  var request = http.MultipartRequest("POST", Uri.parse(ApiEndpoints.upload));
  request.fields['authorId'] = authorId;
  request.files.add(http.MultipartFile.fromBytes('file', file.readAsBytesSync(),filename: filename, contentType: MediaType.parse(lookupMimeType(file.path)??"") ));
  request.fields['filePath'] = path;

  print("Start saving...");

  final result =  await http.Response.fromStream(await request.send());

  print("File saving result: ${json.decode(result.body)}");

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    // final response = BaseResponse.fromJson(json.decode(result.body));
    final response = json.decode(result.body);
    // final product = Product.fromJson(response.data); 
    return ResultModel.success(response["key"], result.statusCode);
  } else {
    var errorBody = jsonDecode(result.body);
    String error = errorBody['errorMessage'] ?? "An error occurred.";
    return ResultModel.fail(error, result.statusCode);
  }
}


// https://stackoverflow.com/questions/63353484/flutter-network-image-to-file

Future<File> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();
    final imageName = url.split('/').last;

    final file = File(join(documentDirectory.path, imageName));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }