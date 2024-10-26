import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/repositories/attendance_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class AttendanceListCubit extends Cubit<ListState<Attendance>> {
  AttendanceListCubit() : super(const ListState());

  final _repository = AttendanceRepository();

  Future<void> getAttendance(String type, String userId,
      {int month = 1}) async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      DateTime now = DateTime.now();
      DateTime lastDayDateTime = (month < 12)
          ? DateTime(now.year, month + 1, 0)
          : DateTime(now.year + 1, 1, 0);
      DateTime startDate = DateTime(now.year, month, 1);
      DateTime endDate = DateTime(now.year, month, lastDayDateTime.day);

      List<Attendance> response = await _repository.getAttendance(
        attendancetype: type,
        startDate: startDate.toString(),
        endDate: endDate.toString(),
        userId: userId,
      );

      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> getAttendancePast(String type, String userId) async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month - 1, now.day - 1);
      DateTime endDate = DateTime(now.year, now.month, now.day+1);

      List<Attendance> response = await _repository.getAttendance(
        attendancetype: type,
        startDate: startDate.toString(),
        endDate: endDate.toString(),
        userId: userId,
      );

      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }
}
