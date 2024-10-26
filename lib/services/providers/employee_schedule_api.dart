import 'package:dio/dio.dart';
import 'package:ess_iris/models/employee_schedule.dart';
import 'package:retrofit/retrofit.dart';

part 'employee_schedule_api.g.dart';

@RestApi()
abstract class EmployeeScheduleApi {
  factory EmployeeScheduleApi(Dio dio, {String baseUrl}) = _EmployeeScheduleApi;

  @GET("/day/{id}")
  Future<EmployeeSchedule> findSchedule(
    @Path("id") int id,
    @Query('identityNumber') String identityNumber,
  );
}
