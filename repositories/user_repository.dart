import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/user_api.dart';
import 'package:ess_iris/services/request/change_password.dart';
import 'package:ess_iris/services/request/claim_password.dart';
import 'package:ess_iris/services/request/forgot_password.dart';
import 'package:ess_iris/services/response/employee_detail.dart';
import 'package:ess_iris/utils/constant.dart';

class UserRepository implements UserApi {
  static final UserRepository _instance = UserRepository._internal();
  static final UserApi _api = UserApi(
    Api.client,
    baseUrl: '$kBaseUrl/users/',
  );

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  @override
  Future<User> me() {
    return _api.me();
  }

  @override
  Future<User> updateUser(String id, User request) {
    return _api.updateUser(id, request);
  }

  @override
  Future<List<User>> getUsers({String? email}) {
    return _api.getUsers(email: email);
  }

  @override
  Future<EmployeeDetailResponse> findCompany(String id) {
    return _api.findCompany(id);
  }

  @override
  Future<EmployeeDetailResponse> findDepartment(String id) {
    return _api.findDepartment(id);
  }

  @override
  Future<EmployeeDetailResponse> findDivision(String id) {
    return _api.findDivision(id);
  }

  @override
  Future<EmployeeDetailResponse> findSubdivision(String id) {
    return _api.findSubdivision(id);
  }

  @override
  Future<User> changePassword(String id, ChangePasswordRequest request) {
    return _api.changePassword(id, request);
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) {
    return _api.forgotPassword(request);
  }

  @override
  Future<void> claimPassword(ClaimPasswordRequest request) {
    return _api.claimPassword(request);
  }
}
