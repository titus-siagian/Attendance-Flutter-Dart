import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/inbox.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/announcement_api.dart';
import 'package:ess_iris/services/providers/inbox_api.dart';
import 'package:ess_iris/utils/constant.dart';

class InboxRepository implements InboxApi {
  static final InboxRepository _instance = InboxRepository._internal();
  static final InboxApi _api = InboxApi(
    Api.client,
    baseUrl: '$kBaseUrl/inbox/',
  );

  factory InboxRepository() {
    return _instance;
  }

  InboxRepository._internal();

  @override
  Future<List<Inbox>> getInbox({String? userId}) {
    return _api.getInbox(userId: userId);
  }
}
