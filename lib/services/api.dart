import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ess_iris/repositories/auth_repository.dart';
import 'package:ess_iris/services/response/error.dart';
import 'package:ess_iris/utils/constant.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:convert';

import 'package:ess_iris/utils/logger.dart';

class Api {
  static final Api _instance = Api._internal();
  final Dio _dio = Dio();

  Api._internal() {
    logger.i("Initializing API client...");
    // _dio.interceptors.add(DioFirebasePerformanceInterceptor());
    _dio.interceptors.add(MyInterceptor());
  }

  static Dio get client => _instance._dio;
}

class MyInterceptor extends Interceptor {
  final _repository = AuthRepository();
  final JsonEncoder _encoder = const JsonEncoder.withIndent(' ');
  final String _baseUrl = kBaseUrl;

  _log(String url, [dynamic data]) {
    final path = url.replaceFirst(_baseUrl, '');
    if (data is Map) {
      String prettyprint = _encoder.convert(data);
      developer.log(
        path,
        name: "hr_mobile",
        error: prettyprint,
      );
    }
  }

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.queryParameters.isNotEmpty) {
      final queryParameters = options.queryParameters.map((key, value) {
        if (value is! Iterable) {
          value = value.toString();
        }
        return MapEntry(key, value);
      });
      final uri = Uri(path: options.path, queryParameters: queryParameters);
      options.path = uri.toString();
      options.queryParameters = {};
    }

    if (options.method != 'GET') {
      if (options.data is Map) {
        _log(
          "=> ${options.method} ${options.uri.toString()}",
          options.data,
        );
      }
    } else {
      logger.e(
        "=> ${options.method} ${options.uri.toString()}",
      );
    }
    String? accessToken = _repository.getToken;
    if (accessToken != null) {
      options.headers['Authorization'] = "Bearer $accessToken";
    }
    super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is! List) {
      Map result = response.data;
      response.data = result['data'];
      if (response.requestOptions.method != 'GET') {
        _log(
          "<= ${response.requestOptions.method} ${response.requestOptions.uri.toString()}",
          response.data,
        );
      }
    }
    super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
        "error ${err.requestOptions.method} ${err.requestOptions.path} $err");
    var error = err.error;
    if (err.response?.data is Map) {
      Map<String, dynamic> data = err.response!.data;
      logger.e(data);
      if (data.containsKey("message")) {
        throw ErrorResponse.fromJson(data);
      }
    } else if (error is SocketException) {
      logger.e('SocketException');
      Map<String, dynamic> errors = {'message': 'No internet connection'};
      throw ErrorResponse.fromJson(errors);
    }
    super.onError(error, handler);
  }
}
