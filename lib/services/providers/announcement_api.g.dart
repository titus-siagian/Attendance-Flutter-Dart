// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _AnnouncementApi implements AnnouncementApi {
  _AnnouncementApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Announcement>> getAnnouncement(
      {company, division, published = true, createdAt, expiredAt}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'company': company,
      r'division': division,
      r'published': published,
      r'createdAt': createdAt,
      r'expiredAt': expiredAt
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<Announcement>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Announcement.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Announcement> findAnnouncement(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Announcement>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Announcement.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<Attachment>> getAttachment(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<Attachment>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '${id}/attachment',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Attachment.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
