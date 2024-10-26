import 'dart:io';

import 'package:ess_iris/models/media.dart';
import 'package:ess_iris/models/question.dart';
import 'package:ess_iris/services/api.dart';
import 'package:ess_iris/services/providers/question_api.dart';
import 'package:ess_iris/services/request/answer.dart';
import 'package:ess_iris/utils/constant.dart';

class QuestionRepository implements QuestionApi {
  static final QuestionRepository _instance = QuestionRepository._internal();
  static final QuestionApi _api = QuestionApi(
    Api.client,
    baseUrl: '$kBaseUrl/question/',
  );

  factory QuestionRepository() {
    return _instance;
  }

  QuestionRepository._internal();

  @override
  Future<Question> getQuestion() {
    return _api.getQuestion();
  }

  @override
  Future<void> validate(AnswerRequest request) {
    return _api.validate(request);
  }
}
