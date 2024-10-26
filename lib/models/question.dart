import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  String? id;
  String? question;
  List<MultipleChoice>? choices;

  Question();

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class MultipleChoice {
  String? code;
  String? text;

  MultipleChoice();

  factory MultipleChoice.fromJson(Map<String, dynamic> json) =>
      _$MultipleChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$MultipleChoiceToJson(this);
}
