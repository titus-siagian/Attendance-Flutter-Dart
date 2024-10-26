import 'package:dio/dio.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/services/request/request_attendance.dart';
import 'package:retrofit/retrofit.dart';

part 'attendance_api.g.dart';

@RestApi()
abstract class AttendanceApi {
  factory AttendanceApi(Dio dio, {String baseUrl}) = _AttendanceApi;

  @GET('/')
  Future<List<Attendance>> getAttendance({
    @Query('currentDate') bool? currentDate,
    @Query('value') String? attendancevalue,
    @Query('type') String? attendancetype,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('userId') String? userId,
  });

  @POST("/")
  Future<Attendance> addAttendance(@Body() Attendance request);

  @POST('/request')
  Future<Attendance> requestAttendance(@Body() AttendanceRequest request);
}
