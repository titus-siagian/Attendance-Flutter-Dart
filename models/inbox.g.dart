// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inbox _$InboxFromJson(Map<String, dynamic> json) => Inbox()
  ..id = json['id'] as int?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..title = json['title'] as String?
  ..body = json['body'] as String?
  ..data = json['data'] as String?;

Map<String, dynamic> _$InboxToJson(Inbox instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
    };
