import 'package:json_annotation/json_annotation.dart';

part 'claim_password.g.dart';

@JsonSerializable()
class ClaimPasswordRequest {
  String? id;
  String? newPassword;

  ClaimPasswordRequest();

  factory ClaimPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ClaimPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimPasswordRequestToJson(this);
}
