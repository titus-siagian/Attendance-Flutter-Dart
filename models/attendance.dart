import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable(includeIfNull: false)
class Attendance {
  String? id;
  DateTime? createdAt;
  String? masterLocationId;
  double? latitude;
  double? longitude;
  String? userId;
  String? description;
  String? photoUrl;
  AttendanceType? type;
  AttendanceValue? value;
  AttendanceProblem? problem;

  Attendance();

  String? get problemName {
    if (problem == null) {
      return null;
    }
    if (problem == AttendanceProblem.a1) {
      return 'Handphone bermasalah';
    }
    if (problem == AttendanceProblem.a2) {
      return 'Tidak bisa login';
    }
    if (problem == AttendanceProblem.a3) {
      return 'Aplikasi bermasalah';
    }
    if (problem == AttendanceProblem.a4) {
      return 'Lupa clock in/out';
    }
    if (problem == AttendanceProblem.a5) {
      return 'Hari libur/cuti/sakit';
    }
    return 'Ganti jadwal';
  }

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}

enum AttendanceType {
  @JsonValue("Live")
  live,
  @JsonValue("Visit")
  visit,
}

enum AttendanceValue {
  @JsonValue("ClockIn")
  clockIn,
  @JsonValue("ClockOut")
  clockOut
}

enum AttendanceProblem {
  @JsonValue("A1")
  a1,
  @JsonValue("A2")
  a2,
  @JsonValue("A3")
  a3,
  @JsonValue("A4")
  a4,
  @JsonValue("A5")
  a5,
  @JsonValue("A6")
  a6
}
