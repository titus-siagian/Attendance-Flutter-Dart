import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hr_mobile/cubit/attendance/attendance.dart';
import 'package:hr_mobile/services/request/request_attendance.dart';
import 'package:hr_mobile/utils/constant.dart';
import 'package:hr_mobile/widgets/input.dart';
import 'package:intl/intl.dart';

import '../../models/attendance.dart';

class RequestAttendPage extends StatefulWidget{
  static const String routename = '/request-attend';

  const RequestAttendPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequestAttendPageState();

}

class _RequestAttendPageState extends State<RequestAttendPage>{

  final now = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  AttendanceRequest request = AttendanceRequest();
  DateTime? _date;
  DateTime? today;
  DateTime? yesterday;
  final _attendanceCubit = AttendanceCubit();
  bool showDateError = false;

  void _showmsg(BuildContext context){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
          content: const Text('Tanggal request hanya berlaku h + 1'),
          action: SnackBarAction(
              label: 'OKE',
              onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  _submit(){
    today = DateTime(now.year, now.month, now.day);
    yesterday = DateTime(now.year, now.month, now.day - 1);
    FocusScope.of(context).unfocus();

    if(showDateError) {
      setState((){
        showDateError = false;
      });
    }

    if (_date != null) {
      if (_date != today || _date != yesterday) {
        return _showmsg(context);
/*        _showmsg(context);
        setState(() {
          showDateError = true;
        });

 */
      }
    }

    if (_formkey.currentState!.validate()){
      _formkey.currentState!.save();
      if(request.longitude == null || request.latitude == null){
        request.latitude = 0;
        request.longitude = 0;
      }

      request.time = _date!.toUtc();
      _attendanceCubit.request(request);
    } else{
      if(_date == null){
        setState((){
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            kMediumSpacing,
            Center(
              child: Text(
                'Request Attendance',
                style: kHugeBook,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kWhiteColor2,
                      primary: kGreyColor2,
                      alignment: Alignment.centerLeft,
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(8),
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
                  ),
                ),
              ],
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
                        'Mohon Pilih Tanggal',
                        style: kSmallBook.copyWith(
                          color: Colors.red,
                        ),
                      ),
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child:
                  DropdownButtonFormField<AttendanceProblem>(
                    hint: const Text('Pilih Alasan'),
                    items: [
                      DropdownMenuItem(
                        child: Text('Handphone Bermasalah'),
                        value: AttendanceProblem.a1,
                      ),
                      DropdownMenuItem(
                        child: Text('Aplikasi Bermalasah'),
                        value: AttendanceProblem.a3,
                      ),
                      DropdownMenuItem(
                        child: Text('Tidak Bisa Login'),
                        value: AttendanceProblem.a2,
                      ),
                      DropdownMenuItem(
                          child: Text('Lupa Clock In/Out'),
                          value: AttendanceProblem.a4,
                      )
                    ],
                    onChanged: (val) {},
                    validator: (AttendanceProblem? val){
                      if (val == null) {
                        return 'Mohon Pilih Alasan';
                      }
                      return null;
                    },
                    onSaved: (val){
                      request.problem = val;
                    },
                  ),
                ),
            ),

            Padding(
                padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 0.0),
                  child: SizedBox(
                    height: 50,
                    width: 350,
                    child:
                    DropdownButtonFormField<AttendanceValue>(
                      hint: const Text('Request Untuk'),
                      items: [
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
                      validator: (AttendanceValue? val){
                        if (val == null) {
                          return 'Mohon Pilih Jenis Request';
                        }
                        return null;
                      },
                      onSaved: (newvalue){
                        request.value = newvalue;
                      }
                    ),
                  ),
            ),
            kSmallSpacing,
            Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              child: SizedBox(
                height: 39,
                width:10,
              ),
            ),
            kLargeSpacing,
            Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: SizedBox(
                    height: 39,
                    width: 10,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          "Request Attendance"
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}