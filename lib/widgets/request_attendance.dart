import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/attendance/attendance.dart';
import 'package:ess_iris/cubit/track_position/track_position_cubit.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/services/request/request_attendance.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/dialog.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/loading.dart';
import 'package:intl/intl.dart';

class RequestAttendanceDialog extends StatefulWidget {
  const RequestAttendanceDialog({Key? key}) : super(key: key);

  @override
  _RequestAttendanceDialogState createState() =>
      _RequestAttendanceDialogState();
}

class _RequestAttendanceDialogState extends State<RequestAttendanceDialog> {
  final now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool showDateError = false;
  DateTime? _date;
  DateTime? _finalDate;
  String? formatDate;
  DateTime? today;
  DateTime? yesterday;
  AttendanceRequest request = AttendanceRequest();
  final _trackCubit = TrackPositionCubit();
  final _attendanceCubit = AttendanceCubit();

  void _showmsg(BuildContext context){
    final scaffold = ScaffoldMessenger.of(context);
    AppError.of(context).show(
      message: 'Request Attend Hanya Dapat Dilakukan Max. Backdate H+1',
    );
  }

  _submit() {
    _finalDate = DateTime(_date!.year, _date!.month, _date!.day);
    today = DateTime(now.year, now.month, now.day);
    yesterday = DateTime(now.year, now.month, now.day - 1);
    FocusScope.of(context).unfocus();
    if (showDateError) {
      setState(() {
        showDateError = false;
      });
    }

    if (_finalDate != today){
      if (_finalDate != yesterday){
        return _showmsg(context);
      }
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (request.longitude == null || request.longitude == null) {
        request.latitude = 0;
        request.longitude = 0;
      }

      request.time = _date!.toUtc();
      _attendanceCubit.request(request);
    } else {
      if (_date == null) {
        setState(() {
          showDateError = true;
        });
      }

    }
  }

  _showDateTime() {
    DatePicker.showDateTimePicker(
      context,
      currentTime: DateTime.now(),
      maxTime: DateTime.now(),
      locale: LocaleType.id,
      onConfirm: (time) {
        setState(() {
          _date = time;
        });
      },
    );
  }

  @override
  void initState() {
    _trackCubit.determinePosition();
    super.initState();
  }

  @override
  void dispose() {
    _trackCubit.close();
    _attendanceCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrackPositionCubit, DetailState<Position>>(
          bloc: _trackCubit,
          listener: (context, state) {
            if (state.status == DetailStateStatus.success) {
              final position = state.data;
              request.latitude = position?.latitude ?? 0;
              request.longitude = position?.longitude ?? 0;
            }
          },
        ),
        BlocListener<AttendanceCubit, DetailState<Attendance>>(
          bloc: _attendanceCubit,
          listenWhen: (previous, current) {
            if (previous.status == DetailStateStatus.loading) {
              Navigator.pop(context);
            }
            return true;
          },
          listener: (context, state) {
            if (state.status == DetailStateStatus.success) {
              Navigator.pop(context, true);
            }
            if (state.status == DetailStateStatus.failure) {
              AppError.of(context).show(
                  message:
                      state.error?.message ?? 'Terjadi kesalahan pada server');
            }
            if (state.status == DetailStateStatus.loading) {
              AppLoading.of(context).show();
            }
          },
        ),
      ],
      child: _buildContent(),
    );
  }

  AppDialog _buildContent() {
    return AppDialog(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Request Live Attendance',
              style: kHugeHeavy,
            ),
            kMediumSpacing,
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kWhiteColor2,
                primary: kGreyColor2,
                alignment: Alignment.centerLeft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: showDateError ? kPrimaryColor : Colors.transparent,
                  ),
                ),
              ),
              onPressed: _showDateTime,
              child: Text(
                _date != null
                    ? DateFormat('dd MMMM yyyy HH:mm').format(_date!)
                    : 'Tanggal',
              ),
            ),
            Visibility(
              visible: showDateError,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Mohon pilih tanggal',
                      style: kSmallBook.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            kMediumSpacing,
            DropdownButtonFormField<AttendanceProblem>(
              hint: const Text('Pilih Alasan'),
              items: const [
                DropdownMenuItem(
                  child: Text('Ganti Jadwal'),
                  value: AttendanceProblem.a6,
                ),
                DropdownMenuItem(
                  child: Text('Handphone bermasalah'),
                  value: AttendanceProblem.a1,
                ),
                DropdownMenuItem(
                  child: Text('Tidak bisa login'),
                  value: AttendanceProblem.a2,
                ),
                DropdownMenuItem(
                  child: Text('Aplikasi bermasalah'),
                  value: AttendanceProblem.a3,
                ),
                DropdownMenuItem(
                  child: Text('Lupa Clock In / Out'),
                  value: AttendanceProblem.a4,
                ),
                // DropdownMenuItem(
                //   child: Text('Hari libur / Cuti / Sakit'),
                //   value: AttendanceProblem.a5,
                // ),
              ],
              onChanged: (val) {},
              validator: (AttendanceProblem? val) {
                if (val == null) {
                  return 'Mohon pilih alasan';
                }
                return null;
              },
              onSaved: (val) {
                request.problem = val;
              },
            ),
            kMediumSpacing,
            DropdownButtonFormField<AttendanceValue>(
              hint: const Text('Request Untuk'),
              items: const [
                DropdownMenuItem(
                  child: Text('Clock In'),
                  value: AttendanceValue.clockIn,
                ),
                DropdownMenuItem(
                  child: Text('Clock Out'),
                  value: AttendanceValue.clockOut,
                ),
              ],
              onChanged: (val) {},
              validator: (AttendanceValue? val) {
                if (val == null) {
                  return 'Mohon pilih jenis request';
                }
                return null;
              },
              onSaved: (newValue) {
                request.value = newValue;
              },
            ),
            kMediumSpacing,
            // AppInput(
            //   placeholder: 'Keterangan',
            //   minLines: 3,
            //   maxLines: 3,
            //   validator: (value) {
            //     if (value?.isEmpty ?? true) {
            //       return 'Mohon masukkan keterangan';
            //     }
            //     return null;
            //   },
            //   onSaved: (value) {
            //     request.description = value ?? '';
            //   },
            // ),
          ],
        ),
      ),
      confirmText: 'Konfirmasi',
      confirm: _submit,
    );
  }
}
