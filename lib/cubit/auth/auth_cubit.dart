import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/media.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/auth_repository.dart';
import 'package:ess_iris/repositories/fcm_repository.dart';
import 'package:ess_iris/repositories/media_repository.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/request/login.dart';
import 'package:ess_iris/services/response/error.dart';
import 'package:ess_iris/services/response/login.dart';
import 'package:ess_iris/utils/logger.dart';

class AuthCubit extends Cubit<DetailState<User>> {
  AuthCubit() : super(const DetailState());

  final _repository = AuthRepository();
  final _fcmRepository = FCMRepository();
  final _userRepository = UserRepository();
  final _mediaRepository = MediaRepository();

  appStarted() {
    String? token = _repository.getToken;
    if (token != null) {
      logger.d("token $token");
      emit(state.copyWith(
        status: DetailStateStatus.success,
        data: User(),
      ));
    } else {
      emit(state.copyWith(status: DetailStateStatus.success));
    }
  }

  Future<void> login(LoginRequest data) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      LoginResponse response = await _repository.login(data);
      logger.d("access token ${response.accessToken}");
      _repository.storeToken(response.accessToken ?? '');

      User user = await _userRepository.me();
      await _repository.storeUserId(user.id ?? '');

      emit(
        state.copyWith(
          status: DetailStateStatus.success,
          data: user,
        ),
      );
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(
          status: DetailStateStatus.failure,
          error: e.error,
        ));
      }
    }
  }

  Future<void> fetchUser() async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      logger.d("fetch user ${state.data?.id}");
      User response = await _userRepository.me();
      await _repository.storeUserId(response.id!);
      emit(state.copyWith(
        status: DetailStateStatus.success,
        data: response,
      ));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> updateUser(User user, {File? file}) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      if (file != null) {
        Media media = await _mediaRepository.addMedia(file);
        user.avatarUrl = media.path;
      }
      User response = await _userRepository.updateUser(user.id ?? '', user);
      emit(state.copyWith(
        status: DetailStateStatus.success,
        data: response,
      ));
    } on DioError catch (e) {
      logger.d(e);
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> logout() async {
    try {
      await _fcmRepository.unsyncFCM(state.data?.id ?? '');
      // ignore: empty_catches
    } catch (e) {}
    await _repository.removeToken();
    emit(const DetailState());
  }
}
