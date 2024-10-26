import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class UserListCubit extends Cubit<ListState<User>> {
  UserListCubit() : super(const ListState());

  final _repository = UserRepository();

  Future<void> getUsers() async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      List<User> response = await _repository.getUsers();
      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }
}
