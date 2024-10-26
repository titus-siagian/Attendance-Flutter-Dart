import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable()
class AnswerRequest {
  String? id;
  String? answer;

  AnswerRequest({this.id, this.answer});

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerRequestToJson(this);
}
