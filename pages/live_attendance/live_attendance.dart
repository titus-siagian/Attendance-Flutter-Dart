import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/cubit/attendance/attendance_list.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/cubit/schedule/schedule_cubit.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/models/employee_schedule.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/pages/attendance/attendance.dart';
import 'package:ess_iris/pages/attendance_detail/attendance_detail.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/empty.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:intl/intl.dart';

class LiveAttendancePage extends StatefulWidget {
  static const String routeName = '/live-attendance';

  const LiveAttendancePage({
    Key? key,
  }) : super(key: key);

  @override
  _LiveAttendancePageState createState() => _LiveAttendancePageState();
}

class _LiveAttendancePageState extends State<LiveAttendancePage> {
  int attendanceMonth = DateTime.now().month;
  final _attendance = Attendance();

  _clockIn(AttendancePageValue value) async {
    AttendancePageArgs args = AttendancePageArgs(
      value: value,
      type: AttendancePageType.live,
    );

    // final checkSchedule = context.read<ScheduleCubit>().state.status;

    // if (checkSchedule == DetailStateStatus.failure) {
    //   await AppError.of(context).show(
    //     message: 'Tanggal masuk / keluar tidak sesuai jadwal.',
    //     title: 'Tidak sesuai jadwal',
    //   );
    // }

    Navigator.pushNamed(context, AttendancePage.routeName, arguments: args)
        .then((value) {
      if (value is bool) {
        _getLog(attendanceMonth);
      }
    });
  }

  _getLastValue(){
    final User user = context.read<AuthCubit>().state.data ?? User();
    context
        .read<AttendanceListCubit>()
        .getAttendancePast('Live', user.id ?? '');
  }

  _getLog(int month) {
    final User user = context.read<AuthCubit>().state.data ?? User();
    context
        .read<AttendanceListCubit>()
        .getAttendance('Live', user.id ?? '', month: month);
  }

  @override
  void initState() {
    _getLog(attendanceMonth);
    final User user = context.read<AuthCubit>().state.data ?? User();
    context
        .read<ScheduleCubit>()
        .findSchedule(DateTime.now().weekday, user.identityNumber ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Live Attendance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 185,
                child: SvgPicture.asset(
                  'assets/svg/bg-red.svg',
                  fit: BoxFit.cover,
                ),
              ),
              _buildTimeDetail()
            ]),
            kSmallSpacing,
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Attendance Log',
                      style: kHugeHeavy.copyWith(color: kDarkBlueColor),
                    ),
                  ),
                  DropdownButton<int>(
                    underline: const SizedBox(),
                    value: attendanceMonth,
                    items: List.generate(12, (val) {
                      return DropdownMenuItem(
                        child: Text(DateFormat('MMMM').format(
                          DateTime(2020, val + 1),
                        )),
                        value: val + 1,
                      );
                    }),
                    onChanged: (val) {
                      if (attendanceMonth != (val ?? 0)) {
                        setState(() {
                          attendanceMonth = val ?? 0;
                        });
                        _getLog(attendanceMonth);
                      }
                    },
                  ),
                ],
              ),
            ),
            kMediumSpacing,
            BlocBuilder<AttendanceListCubit, ListState<Attendance>>(
              builder: (context, state) {
                if (state.status == ListStateStatus.success) {
                  if (state.data?.isNotEmpty ?? false) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildLog(state.data!),
                    );
                  }
                  return const AppEmpty();
                }
                if (state.status == ListStateStatus.failure) {
                  return AppEmpty(
                    message: state.error?.message ?? 'Terjadi kesalahan',
                  );
                }
                return const SizedBox();
              },
            ),
            kLargeSpacing
          ],
        ),
      ),
    );
  }

  SafeArea _buildTimeDetail() {
    return SafeArea(
      child: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            kLargeSpacing,
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        DateFormat('HH:mm').format(DateTime.now()),
                        style: kBigHeaderHeavy.copyWith(color: kWhiteColor),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                        style: kMediumMedium.copyWith(color: kWhiteColor),
                      ),
                    ),
                  ],
                );
              },
            ),
            kMediumSpacing,
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    BlocBuilder<ScheduleCubit, DetailState<EmployeeSchedule>>(
                      builder: (context, state) {
                        if (state.status == DetailStateStatus.success) {
                          return Text(
                            '${state.data?.startTimeConvert ?? ''} - ${state.data?.endTimeConvert ?? ''}',
                            style: kHeaderHeavy.copyWith(
                              color: kDarkBlueColor,
                            ),
                          );
                        }
                        if (state.status == DetailStateStatus.failure) {
                          return Text(
                            'Belum ada jadwal',
                            style: kGiantHeavy.copyWith(
                              color: kDarkBlueColor,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: kDefaultPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: ()
                              // => _clockIn(AttendancePageValue.clockIn),
                              {
                                _getLastValue();
                                final data = context.read<AttendanceListCubit>().state.data;
                                for (var i = 0; i < data!.length; i++){
                                  if (data[i].value!.index == 0)
                                  {
                                    AppError.of(context).show(
                                      message: 'Posisi absen terakhir Anda adalah ClockIn, mohon pilih ClockOut',
                                    );
                                    return;
                                  } else {
                                    _clockIn(AttendancePageValue.clockIn);
                                    return;
                                  }
                                }
                                _clockIn(AttendancePageValue.clockIn);

                              },
                              child: const Text('Clock In'),
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: ()
                              // => _clockIn(AttendancePageValue.clockOut),
                              {
                                _getLastValue();
                                final data = context.read<AttendanceListCubit>().state.data;
                                for (var i = 0; i < data!.length; i++){
                                  if (data[i].value!.index == 1)
                                  {
                                    AppError.of(context).show(
                                      message: 'Posisi absen terakhir Anda adalah ClockOut, mohon pilih ClockIn',
                                    );
                                    return;
                                  } else {
                                    _clockIn(AttendancePageValue.clockOut);
                                    return;
                                  }
                                }
                                _clockIn(AttendancePageValue.clockOut);

                              },
                              child: const Text('Clock Out'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLog(List<Attendance> data) {
    List<Widget> widgets = [];

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final itemN = i != 0 ? data[i - 1] : null;

      if (itemN != null) {
        final getDate = item.createdAt!.toLocal().day;
        final dateItemN = itemN.createdAt!.toLocal().day;

        if (getDate == dateItemN) {
          widgets.add(_buildTile(item));
        } else {
          widgets.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
              Padding(
                padding: kDefaultPadding,
                child: Text(
                  DateFormat('dd MMMM yyyy')
                      .format(item.createdAt?.toLocal() ?? DateTime.now()),
                  style: kLargeHeavy.copyWith(color: kDarkBlueColor),
                ),
              ),
              _buildTile(item),
            ],
          ));
        }
      } else {
        widgets.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kDefaultPadding,
              child: Text(
                DateFormat('dd MMMM yyyy')
                    .format(item.createdAt?.toLocal() ?? DateTime.now()),
                style: kLargeHeavy.copyWith(color: kDarkBlueColor),
              ),
            ),
            _buildTile(item),
          ],
        ));
      }
    }
    return widgets;
  }

  ListTile _buildTile(Attendance data) {
    final convertTime = DateFormat('HH:mm').format(data.createdAt!.toLocal());
    return ListTile(
      leading: Text(
        convertTime,
        style: kLargeMedium.copyWith(color: kDarkBlueColor),
      ),
      title: Text(
        data.value!.index == 0 ? 'Clock In' : 'Clock Out',
        style: kLargeMedium,
      ),
      subtitle: data.problem != null ? Text(data.problemName!) : null,
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      horizontalTitleGap: 40,
      dense: true,
      onTap: () {
        Navigator.pushNamed(
          context,
          AttendanceDetailPage.routeName,
          arguments: data,
        );
      },
    );
  }
}
