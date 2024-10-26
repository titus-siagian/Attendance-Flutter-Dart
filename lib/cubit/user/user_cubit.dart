import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/request/change_password.dart';
import 'package:ess_iris/services/response/error.dart';

class UserCubit extends Cubit<DetailState<User>> {
  UserCubit() : super(const DetailState());

  final _repository = UserRepository();

  Future<void> changePassword(String id, ChangePasswordRequest request) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      User response = await _repository.changePassword(id, request);
      emit(state.copyWith(status: DetailStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
