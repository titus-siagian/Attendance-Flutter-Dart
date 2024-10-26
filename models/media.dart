
import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable()
class Media {
  String? name;
  String? path;

  Media();

  factory Media.fromJson(Map<String, dynamic> json) =>
      _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
