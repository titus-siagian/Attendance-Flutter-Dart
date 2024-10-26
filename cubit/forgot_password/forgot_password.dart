import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/request/claim_password.dart';
import 'package:ess_iris/services/request/forgot_password.dart';
import 'package:ess_iris/services/response/error.dart';

class ForgotPasswordCubit extends Cubit<DetailState<bool>> {
  ForgotPasswordCubit() : super(const DetailState());

  final _repository = UserRepository();

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      await _repository.forgotPassword(request);
      emit(state.copyWith(status: DetailStateStatus.success, data: true));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> claimPassword(ClaimPasswordRequest request) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      await _repository.claimPassword(request);
      emit(state.copyWith(status: DetailStateStatus.success, data: true));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
