import 'package:ess_iris/models/employee_schedule.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/employee_schedule_api.dart';
import 'package:ess_iris/utils/constant.dart';

class EmployeeScheduleRepository implements EmployeeScheduleApi {
  static final EmployeeScheduleRepository _instance =
      EmployeeScheduleRepository._internal();
  static final EmployeeScheduleApi _api = EmployeeScheduleApi(
    Api.client,
    baseUrl: '$kBaseUrl/employee-schedule/',
  );

  factory EmployeeScheduleRepository() {
    return _instance;
  }

  EmployeeScheduleRepository._internal();

  @override
  Future<EmployeeSchedule> findSchedule(int dayIndex, String identityNumber) {
    return _api.findSchedule(dayIndex, identityNumber);
  }
}
