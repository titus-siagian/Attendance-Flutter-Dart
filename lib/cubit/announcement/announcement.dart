import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/repositories/announcement_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class AnnouncementCubit extends Cubit<DetailState<Announcement>> {
  AnnouncementCubit() : super(const DetailState());

  final _repository = AnnouncementRepository();

  Future<void> find(int id) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      Announcement response = await _repository.findAnnouncement(id);

      emit(state.copyWith(status: DetailStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
