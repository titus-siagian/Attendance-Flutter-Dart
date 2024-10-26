// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRequest _$AttendanceRequestFromJson(Map<String, dynamic> json) =>
    AttendanceRequest(
      type: $enumDecodeNullable(_$AttendanceTypeEnumMap, json['type']) ??
          AttendanceType.live,
    )
      ..time =
          json['time'] == null ? null : DateTime.parse(json['time'] as String)
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..description = json['description'] as String?
      ..value = $enumDecodeNullable(_$AttendanceValueEnumMap, json['value'])
      ..problem =
          $enumDecodeNullable(_$AttendanceProblemEnumMap, json['problem']);

Map<String, dynamic> _$AttendanceRequestToJson(AttendanceRequest instance) =>
    <String, dynamic>{
      'time': instance.time?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'type': _$AttendanceTypeEnumMap[instance.type],
      'value': _$AttendanceValueEnumMap[instance.value],
      'problem': _$AttendanceProblemEnumMap[instance.problem],
    };

const _$AttendanceTypeEnumMap = {
  AttendanceType.live: 'Live',
  AttendanceType.visit: 'Visit',
};

const _$AttendanceValueEnumMap = {
  AttendanceValue.clockIn: 'ClockIn',
  AttendanceValue.clockOut: 'ClockOut',
};

const _$AttendanceProblemEnumMap = {
  AttendanceProblem.a1: 'A1',
  AttendanceProblem.a2: 'A2',
  AttendanceProblem.a3: 'A3',
  AttendanceProblem.a4: 'A4',
  AttendanceProblem.a5: 'A5',
  AttendanceProblem.a6: 'A6',
};
