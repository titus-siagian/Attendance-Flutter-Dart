import 'package:json_annotation/json_annotation.dart';

part 'employee_detail.g.dart';

@JsonSerializable()
class EmployeeDetailResponse {
  String? id;
  String? name;

  EmployeeDetailResponse({this.id, this.name});

  factory EmployeeDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployeeDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeDetailResponseToJson(this);
}
