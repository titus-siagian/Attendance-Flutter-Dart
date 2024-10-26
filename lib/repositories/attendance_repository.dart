import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/attendance_api.dart';
import 'package:ess_iris/services/request/request_attendance.dart';
import 'package:ess_iris/utils/constant.dart';

class AttendanceRepository implements AttendanceApi {
  static final AttendanceRepository _instance =
      AttendanceRepository._internal();
  static final AttendanceApi _api = AttendanceApi(
    Api.client,
    baseUrl: '$kBaseUrl/attendance/',
  );

  factory AttendanceRepository() {
    return _instance;
  }

  AttendanceRepository._internal();

  @override
  Future<Attendance> addAttendance(Attendance request) {
    return _api.addAttendance(request);
  }

  @override
  Future<List<Attendance>> getAttendance({
    bool? currentDate,
    String? attendancevalue,
    String? attendancetype,
    String? startDate,
    String? endDate,
    String? userId,
  }) {
    return _api.getAttendance(
      currentDate: currentDate,
      attendancevalue: attendancevalue,
      attendancetype: attendancetype,
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
  }

  @override
  Future<Attendance> requestAttendance(AttendanceRequest request) {
    return _api.requestAttendance(request);
  }
}
