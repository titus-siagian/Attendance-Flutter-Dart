import 'package:dio/dio.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/attachment.dart';
import 'package:retrofit/retrofit.dart';

part 'announcement_api.g.dart';

@RestApi()
abstract class AnnouncementApi {
  factory AnnouncementApi(Dio dio, {String baseUrl}) = _AnnouncementApi;

  @GET("/")
  Future<List<Announcement>> getAnnouncement({
    @Query('company') String? company,
    @Query('division') String? division,
    @Query('published') bool published = true,
    @Query('createdAt') String? createdAt,
    @Query('expiredAt') String? expiredAt,
  });

  @GET("{id}")
  Future<Announcement> findAnnouncement(@Path('id') int id);

  @GET("{id}/attachment")
  Future<List<Attachment>> getAttachment(@Path('id') int id);
}
