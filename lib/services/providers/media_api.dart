import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ess_iris/models/media.dart';
import 'package:retrofit/retrofit.dart';

part 'media_api.g.dart';

@RestApi()
abstract class MediaApi {
  factory MediaApi(Dio dio, {String baseUrl}) = _MediaApi;

  @POST("/")
  Future<Media> addMedia(@Part(name: 'file') File file);
}
