import 'dart:io';

import 'package:ess_iris/models/media.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/media_api.dart';
import 'package:ess_iris/utils/constant.dart';

class MediaRepository implements MediaApi {
  static final MediaRepository _instance = MediaRepository._internal();
  static final MediaApi _api = MediaApi(
    Api.client,
    baseUrl: '$kBaseUrl/files/',
  );

  factory MediaRepository() {
    return _instance;
  }

  MediaRepository._internal();

  @override
  Future<Media> addMedia(File file) {
    return _api.addMedia(file);
  }
}
