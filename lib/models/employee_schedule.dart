import 'package:json_annotation/json_annotation.dart';

part 'employee_schedule.g.dart';

@JsonSerializable()
class EmployeeSchedule {
  int? startTime;
  int? endTime;

  EmployeeSchedule();

  int get startTimeHour {
    return ((startTime ?? 0) / 60).floor();
  }

  int get startTimeMinute {
    return ((startTime ?? 0) % 60);
  }

  String get startTimeConvert {
    String getHour = startTimeHour.toString().padLeft(2, '0');
    String getMinute = startTimeMinute.toString().padLeft(2, '0');
    return '$getHour:$getMinute';
  }

  int get endTimeHour {
    return ((endTime ?? 0) / 60).floor();
  }

  int get endTimeMinute {
    return ((endTime ?? 0) % 60);
  }

  String get endTimeConvert {
    String getHour = endTimeHour.toString().padLeft(2, '0');
    String getMinute = endTimeMinute.toString().padLeft(2, '0');
    return '$getHour:$getMinute';
  }

  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeScheduleToJson(this);
}
