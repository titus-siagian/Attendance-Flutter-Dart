import 'package:dio/dio.dart';
import 'package:ess_iris/models/device.dart';
import 'package:ess_iris/services/request/device.dart';
import 'package:ess_iris/services/request/login.dart';
import 'package:ess_iris/services/response/login.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("/")
  Future<LoginResponse> login(@Body() LoginRequest data);

  @GET("/device/{id}")
  Future<Device> getDeviceId(@Path("id") String id);

  @POST("/device")
  Future<Device> addDeviceId(@Body() DeviceRequest request);
}
