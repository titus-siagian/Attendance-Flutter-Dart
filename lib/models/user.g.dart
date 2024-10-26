// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
    )
      ..active = json['active'] as bool?
      ..identityNumber = json['identityNumber'] as String?
      ..name = json['name'] as String?
      ..email = json['email'] as String?
      ..avatarUrl = json['avatarUrl'] as String?
      ..address = json['address'] as String?
      ..phone = json['phone'] as String?
      ..dateOfBirth = json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String)
      ..placeOfBirth = json['placeOfBirth'] as String?
      ..location = json['location'] as String?
      ..position = json['position'] as String?
      ..sex = json['sex'] as int?
      ..blood = json['blood'] as String?
      ..subdivisionId = json['subdivisionId'] as String?
      ..divisionId = json['divisionId'] as String?
      ..companyId = json['companyId'] as String?
      ..departmentId = json['departmentId'] as String?
      ..role = $enumDecodeNullable(_$RoleEnumMap, json['role']);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'active': instance.active,
      'id': instance.id,
      'identityNumber': instance.identityNumber,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'address': instance.address,
      'phone': instance.phone,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'placeOfBirth': instance.placeOfBirth,
      'location': instance.location,
      'position': instance.position,
      'sex': instance.sex,
      'blood': instance.blood,
      'subdivisionId': instance.subdivisionId,
      'divisionId': instance.divisionId,
      'companyId': instance.companyId,
      'departmentId': instance.departmentId,
      'role': _$RoleEnumMap[instance.role],
    };

const _$RoleEnumMap = {
  Role.USER: 'USER',
  Role.ADMIN: 'ADMIN',
};
