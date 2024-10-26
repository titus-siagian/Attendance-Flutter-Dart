import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ess_iris/models/question.dart';
import 'package:ess_iris/services/request/answer.dart';
import 'package:retrofit/retrofit.dart';

part 'question_api.g.dart';

@RestApi()
abstract class QuestionApi {
  factory QuestionApi(Dio dio, {String baseUrl}) = _QuestionApi;

  @POST("/")
  Future<Question> getQuestion();

  @POST("validate")
  Future<void> validate(@Body() AnswerRequest request);
}
