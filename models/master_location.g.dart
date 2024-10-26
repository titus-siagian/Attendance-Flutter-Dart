// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterLocation _$MasterLocationFromJson(Map<String, dynamic> json) =>
    MasterLocation()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..address = json['address'] as String?
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..radius = (json['radius'] as num?)?.toDouble();

Map<String, dynamic> _$MasterLocationToJson(MasterLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
    };
