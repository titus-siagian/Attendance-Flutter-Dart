import 'package:ess_iris/models/attendance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_attendance.g.dart';

@JsonSerializable()
class AttendanceRequest {
  DateTime? time;
  double? latitude;
  double? longitude;
  String? description;
  AttendanceType? type;
  AttendanceValue? value;
  AttendanceProblem? problem;

  AttendanceRequest({this.type = AttendanceType.live});

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRequestToJson(this);
}
