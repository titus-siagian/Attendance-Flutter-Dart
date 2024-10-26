import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/announcement_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class AnnouncementListCubit extends Cubit<ListState<Announcement>> {
  AnnouncementListCubit() : super(const ListState());

  final _repository = AnnouncementRepository();

  Future<void> getAnnouncement(User user) async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      List<Announcement> response = await _repository.getAnnouncement(
        company: user.companyId,
        division: user.divisionId,
        expiredAt: DateTime.now().toString(),
      );
      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }
}
