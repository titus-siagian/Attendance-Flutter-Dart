// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance()
  ..id = json['id'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..masterLocationId = json['masterLocationId'] as String?
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..userId = json['userId'] as String?
  ..description = json['description'] as String?
  ..photoUrl = json['photoUrl'] as String?
  ..type = $enumDecodeNullable(_$AttendanceTypeEnumMap, json['type'])
  ..value = $enumDecodeNullable(_$AttendanceValueEnumMap, json['value'])
  ..problem = $enumDecodeNullable(_$AttendanceProblemEnumMap, json['problem']);

Map<String, dynamic> _$AttendanceToJson(Attendance instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('masterLocationId', instance.masterLocationId);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('userId', instance.userId);
  writeNotNull('description', instance.description);
  writeNotNull('photoUrl', instance.photoUrl);
  writeNotNull('type', _$AttendanceTypeEnumMap[instance.type]);
  writeNotNull('value', _$AttendanceValueEnumMap[instance.value]);
  writeNotNull('problem', _$AttendanceProblemEnumMap[instance.problem]);
  return val;
}

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
