class BaseResponse {
  int? code;
  String? message;

  BaseResponse({this.message, this.code});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(message: json["message"], code: json['statusCode']);
  }
}
