import 'package:hive_flutter/hive_flutter.dart';
import 'package:ess_iris/models/device.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/auth_api.dart';
import 'package:ess_iris/services/request/device.dart';
import 'package:ess_iris/services/request/login.dart';
import 'package:ess_iris/services/response/login.dart';
import 'package:ess_iris/utils/constant.dart';

class AuthRepository implements AuthApi {
  static final AuthRepository _instance = AuthRepository._internal();
  static final AuthApi _api = AuthApi(
    Api.client,
    baseUrl: '$kBaseUrl/auth/',
  );

  factory AuthRepository() {
    return _instance;
  }

  AuthRepository._internal();

  @override
  Future<LoginResponse> login(LoginRequest data) {
    return _api.login(data);
  }

  Future<void> storeUserId(String userId) async {
    var box = Hive.box('user');
    String? checkId = box.get('userId');
    if (checkId?.isEmpty ?? true) {
      await box.put('userId', userId);
    }
  }

  String? get getUserId {
    var box = Hive.box('user');
    return box.get('userId');
  }

  void storeToken(String accessToken) {
    var box = Hive.box('user');
    box.put('token', accessToken);
  }

  String? get getToken {
    var box = Hive.box('user');
    return box.get('token');
  }

  Future<void> removeToken() async {
    var box = Hive.box('user');
    await box.clear();
  }

  @override
  Future<Device> addDeviceId(DeviceRequest request) {
    return _api.addDeviceId(request);
  }

  @override
  Future<Device> getDeviceId(String id) {
    return _api.getDeviceId(id);
  }
}
