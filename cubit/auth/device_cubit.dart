import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/device.dart';
import 'package:ess_iris/repositories/auth_repository.dart';
import 'package:ess_iris/services/request/device.dart';
import 'package:ess_iris/services/response/error.dart';

class DeviceCubit extends Cubit<DetailState<Device>> {
  DeviceCubit() : super(const DetailState());

  final _repository = AuthRepository();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> fetchDeviceId(String userId) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      Device response = await _repository.getDeviceId(userId);

      if (response.deviceId == null) {
        late String deviceId;

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId = androidInfo.androidId;
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor;
        }

        DeviceRequest request = DeviceRequest();
        request.id = deviceId;
        request.userId = userId;
        response = await _repository.addDeviceId(request);
      }

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
}
