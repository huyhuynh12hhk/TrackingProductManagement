
class ResultModel<T> {
  final T? data;
  final bool isSuccess;
  final String errorMessage;
  final int statusCode;
  const ResultModel(
      {this.data,
      this.isSuccess = false,
      this.errorMessage = "",
      required this.statusCode});

  factory ResultModel.fail(String error, int statusCode) => ResultModel(
      errorMessage: error, isSuccess: false, statusCode: statusCode);

  factory ResultModel.success(T data, int statusCode) =>
      ResultModel(data: data, isSuccess: true, statusCode: statusCode);
}