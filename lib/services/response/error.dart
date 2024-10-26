import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class ErrorResponse implements Exception {
  String? message;
  int? statusCode;

  ErrorResponse({this.message, this.statusCode});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() {
    return "ErrorResponse: $message statusCode: $statusCode";
  }
}
