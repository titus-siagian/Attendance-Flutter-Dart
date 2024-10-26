import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/models/media.dart';
import 'package:ess_iris/repositories/attendance_repository.dart';
import 'package:ess_iris/repositories/media_repository.dart';
import 'package:ess_iris/services/request/request_attendance.dart';
import 'package:ess_iris/services/response/error.dart';

class AttendanceCubit extends Cubit<DetailState<Attendance>> {
  AttendanceCubit() : super(const DetailState());

  final _repository = AttendanceRepository();
  final _mediaRepository = MediaRepository();

  Future<void> addAttendance(Attendance data, {File? file}) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      if (file != null) {
        Media media = await _mediaRepository.addMedia(file);
        data.photoUrl = media.path;
      }

      Attendance response = await _repository.addAttendance(data);
      emit(state.copyWith(
        data: response,
        status: DetailStateStatus.success,
      ));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> request(AttendanceRequest data) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      Attendance response = await _repository.requestAttendance(data);
      emit(state.copyWith(
        data: response,
        status: DetailStateStatus.success,
      ));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
