import 'package:json_annotation/json_annotation.dart';

part 'inbox.g.dart';

@JsonSerializable()
class Inbox {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  String? body;
  String? data;

  Inbox();

  factory Inbox.fromJson(Map<String, dynamic> json) => _$InboxFromJson(json);
  Map<String, dynamic> toJson() => _$InboxToJson(this);
}
