import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/fcm_api.dart';
import 'package:ess_iris/services/request/fcm.dart';
import 'package:ess_iris/utils/constant.dart';

class FCMRepository implements FCMApi {
  static final FCMRepository _instance = FCMRepository._internal();
  static final FCMApi _api = FCMApi(
    Api.client,
    baseUrl: '$kBaseUrl/fcm/',
  );

  factory FCMRepository() {
    return _instance;
  }

  FCMRepository._internal();

  @override
  Future<void> syncFCM(String userId, FCMRequest request) {
    return _api.syncFCM(userId, request);
  }

  @override
  Future<void> unsyncFCM(String userId) {
    return _api.unsyncFCM(userId);
  }
}
