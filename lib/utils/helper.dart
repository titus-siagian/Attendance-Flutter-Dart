import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/utils/logger.dart';

class Helper {
  static Future<void> blockUser(String email) async {
    try {
      final findUsers = await UserRepository().getUsers(email: email);
      if (findUsers.isNotEmpty) {
        final user = findUsers.first;
        user.active = false;
        await UserRepository().updateUser(user.id ?? '', user);
      }
    } catch (e) {
      logger.d("error block user $e");
    }
  }
}
