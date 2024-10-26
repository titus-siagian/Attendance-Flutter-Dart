import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/employee_schedule.dart';
import 'package:ess_iris/repositories/employee_schedule_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class ScheduleCubit extends Cubit<DetailState<EmployeeSchedule>> {
  ScheduleCubit() : super(const DetailState());

  final _repository = EmployeeScheduleRepository();

  Future<void> findSchedule(int dayIndex, String identityNumber) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      EmployeeSchedule response =
          await _repository.findSchedule(dayIndex, identityNumber);
      emit(state.copyWith(status: DetailStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
