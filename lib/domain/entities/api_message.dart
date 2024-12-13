class ApiMessage {
  final int? code;
  final String? message;

  ApiMessage({this.code, this.message});

  factory ApiMessage.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return ApiMessage(
        code: json.containsKey("code") ? json["code"] : null,
        message: json.containsKey("message") ? json["message"] : null,
      );
    } else {
      return ApiMessage(
        code: null,
        message: null,
      );
    }
  }
}
