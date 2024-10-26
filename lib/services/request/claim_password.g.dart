// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimPasswordRequest _$ClaimPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ClaimPasswordRequest()
      ..id = json['id'] as String?
      ..newPassword = json['newPassword'] as String?;

Map<String, dynamic> _$ClaimPasswordRequestToJson(
        ClaimPasswordRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'newPassword': instance.newPassword,
    };
