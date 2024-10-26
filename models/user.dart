// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  bool? active;
  String? id;
  String? identityNumber;
  String? name;
  String? email;
  String? avatarUrl;
  String? address;
  String? phone;
  DateTime? dateOfBirth;
  String? placeOfBirth;
  String? location;
  String? position;
  int? sex;
  String? blood;
  String? subdivisionId;
  String? divisionId;
  String? companyId;
  String? departmentId;
  Role? role;

  User({this.id});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum Role { USER, ADMIN }
