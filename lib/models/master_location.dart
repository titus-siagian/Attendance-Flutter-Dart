import 'package:json_annotation/json_annotation.dart';

part 'master_location.g.dart';

@JsonSerializable()
class MasterLocation {
  String? id;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  double? radius;

  MasterLocation();

  factory MasterLocation.fromJson(Map<String, dynamic> json) =>
      _$MasterLocationFromJson(json);
  Map<String, dynamic> toJson() => _$MasterLocationToJson(this);
}

