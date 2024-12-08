import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  final dynamic data;
  final bool isSuccess;
  final String errorMessage;
  const BaseResponse(
      {required this.data, this.isSuccess = false, this.errorMessage = ""});

  factory BaseResponse.fromJson(Map<String, dynamic> response) {
    return _$BaseResponseFromJson(response);
  }

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
