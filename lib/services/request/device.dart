import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class DeviceRequest {
  String? id;
  String? userId;

  DeviceRequest();

  factory DeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceRequestToJson(this);
}
