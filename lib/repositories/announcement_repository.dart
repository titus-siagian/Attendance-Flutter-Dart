import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/attachment.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/announcement_api.dart';
import 'package:ess_iris/utils/constant.dart';

class AnnouncementRepository implements AnnouncementApi {
  static final AnnouncementRepository _instance =
      AnnouncementRepository._internal();
  static final AnnouncementApi _api = AnnouncementApi(
    Api.client,
    baseUrl: '$kBaseUrl/announcement/',
  );

  factory AnnouncementRepository() {
    return _instance;
  }

  AnnouncementRepository._internal();

  @override
  Future<List<Announcement>> getAnnouncement({
    String? company,
    String? division,
    bool published = true,
    String? createdAt,
    String? expiredAt,
  }) {
    return _api.getAnnouncement(
      company: company,
      division: division,
      published: published,
      createdAt: createdAt,
      expiredAt: expiredAt,
    );
  }

  @override
  Future<Announcement> findAnnouncement(int id) {
    return _api.findAnnouncement(id);
  }

  @override
  Future<List<Attachment>> getAttachment(int id) {
    return _api.getAttachment(id);
  }
}
