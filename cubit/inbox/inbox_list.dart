import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/models/inbox.dart';
import 'package:ess_iris/repositories/inbox_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class InboxListCubit extends Cubit<ListState<Inbox>> {
  InboxListCubit() : super(const ListState());

  final _repository = InboxRepository();

  Future<void> getInbox(String userId) async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      List<Inbox> response = await _repository.getInbox(userId: userId);

      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }
}
