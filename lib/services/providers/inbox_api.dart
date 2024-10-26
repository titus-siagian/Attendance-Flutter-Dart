import 'package:dio/dio.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/inbox.dart';
import 'package:retrofit/retrofit.dart';

part 'inbox_api.g.dart';

@RestApi()
abstract class InboxApi {
  factory InboxApi(Dio dio, {String baseUrl}) = _InboxApi;

  @GET("/")
  Future<List<Inbox>> getInbox({
    @Query('userId') String? userId,
  });
}
