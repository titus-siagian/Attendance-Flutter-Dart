// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeSchedule _$EmployeeScheduleFromJson(Map<String, dynamic> json) =>
    EmployeeSchedule()
      ..startTime = json['startTime'] as int?
      ..endTime = json['endTime'] as int?;

Map<String, dynamic> _$EmployeeScheduleToJson(EmployeeSchedule instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
