// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question()
  ..id = json['id'] as String?
  ..question = json['question'] as String?
  ..choices = (json['choices'] as List<dynamic>?)
      ?.map((e) => MultipleChoice.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'choices': instance.choices,
    };

MultipleChoice _$MultipleChoiceFromJson(Map<String, dynamic> json) =>
    MultipleChoice()
      ..code = json['code'] as String?
      ..text = json['text'] as String?;

Map<String, dynamic> _$MultipleChoiceToJson(MultipleChoice instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
    };
