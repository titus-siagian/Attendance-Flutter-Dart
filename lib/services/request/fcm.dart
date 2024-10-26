import 'package:json_annotation/json_annotation.dart';

part 'fcm.g.dart';

@JsonSerializable()
class FCMRequest {
  String? token;

  FCMRequest({this.token});

  factory FCMRequest.fromJson(Map<String, dynamic> json) =>
      _$FCMRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FCMRequestToJson(this);
}
