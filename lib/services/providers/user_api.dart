import 'package:dio/dio.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/services/request/change_password.dart';
import 'package:ess_iris/services/request/claim_password.dart';
import 'package:ess_iris/services/request/forgot_password.dart';
import 'package:ess_iris/services/response/employee_detail.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("me")
  Future<User> me();

  @GET("/")
  Future<List<User>> getUsers({@Query('email') String? email});

  @PATCH("{id}")
  Future<User> updateUser(@Path("id") String id, @Body() User request);

  @PATCH("{id}/change-password")
  Future<User> changePassword(
    @Path("id") String id,
    @Body() ChangePasswordRequest request,
  );

  @GET("/company/{id}")
  Future<EmployeeDetailResponse> findCompany(@Path("id") String id);

  @GET("/division/{id}")
  Future<EmployeeDetailResponse> findDivision(@Path("id") String id);

  @GET("/subdivision/{id}")
  Future<EmployeeDetailResponse> findSubdivision(@Path("id") String id);

  @GET("/department/{id}")
  Future<EmployeeDetailResponse> findDepartment(@Path("id") String id);

  @POST("/forgot-password")
  Future<void> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST("/forgot-password/claim")
  Future<void> claimPassword(@Body() ClaimPasswordRequest request);
}
