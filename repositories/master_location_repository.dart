import 'package:ess_iris/models/master_location.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/master_location_api.dart';
import 'package:ess_iris/utils/constant.dart';

class MasterLocationRepository implements MasterLocationApi {
  static final MasterLocationRepository _instance =
      MasterLocationRepository._internal();
  static final MasterLocationApi _api = MasterLocationApi(
    Api.client,
    baseUrl: '$kBaseUrl/master-locations/',
  );

  factory MasterLocationRepository() {
    return _instance;
  }

  MasterLocationRepository._internal();

  @override
  Future<List<MasterLocation>> getMasterLocation(
      double latitude, double longitude) {
    return _api.getMasterLocation(latitude, longitude);
  }
}
