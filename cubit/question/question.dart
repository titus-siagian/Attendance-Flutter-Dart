import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/models/question.dart';
import 'package:ess_iris/repositories/question_repository.dart';
import 'package:ess_iris/services/request/answer.dart';
import 'package:ess_iris/services/response/error.dart';

class QuestionCubit extends Cubit<DetailState<Question>> {
  QuestionCubit() : super(const DetailState());

  final _repository = QuestionRepository();

  Future<void> getQuestion() async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      Question response = await _repository.getQuestion();
      emit(state.copyWith(status: DetailStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }

  Future<void> validate(String id, String answer) async {
    emit(state.copyWith(status: DetailStateStatus.loading));
    try {
      await _repository.validate(AnswerRequest(
        id: id,
        answer: answer,
      ));
      emit(state.copyWith(status: DetailStateStatus.success, data: null));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: DetailStateStatus.failure, error: e.error));
      }
    }
  }
}
