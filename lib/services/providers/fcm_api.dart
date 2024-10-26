import 'package:dio/dio.dart';
import 'package:ess_iris/services/request/fcm.dart';
import 'package:retrofit/retrofit.dart';

part 'fcm_api.g.dart';

@RestApi()
abstract class FCMApi {
  factory FCMApi(Dio dio, {String baseUrl}) = _FCMApi;

  @PATCH("/{userId}/sync")
  Future<void> syncFCM(
      @Path('userId') String userId, @Body() FCMRequest request);

  @PATCH('/{userId}/unsync')
  Future<void> unsyncFCM(@Path('userId') String userId);
}
