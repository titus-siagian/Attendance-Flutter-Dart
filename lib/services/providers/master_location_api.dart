import 'package:dio/dio.dart';
import 'package:ess_iris/models/master_location.dart';
import 'package:retrofit/retrofit.dart';

part 'master_location_api.g.dart';

@RestApi()
abstract class MasterLocationApi {
  factory MasterLocationApi(Dio dio, {String baseUrl}) = _MasterLocationApi;

  @GET("/nearest")
  Future<List<MasterLocation>> getMasterLocation(
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
  );
}
