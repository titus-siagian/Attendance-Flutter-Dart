import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hr_mobile/utils/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/logger.dart';

class AbsentPage extends StatefulWidget{
  static const String routename = '/absent-attendance';
  const AbsentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AbsentPageState();
}

class _AbsentPageState extends State<AbsentPage> {

  final _formkey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  DateTime? _date;
  bool showDateError = false;
  String lokasi_file = "";
  PlatformFile? file;
  FilePickerResult? result;

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

  _pickFile() async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
      );
      if (result != null){
        file = result.files.first;
      }
    } catch (e){
      logger.e(e);
    }
  }

  /*_pickImage() async {
    try {
      XFile? getFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 720,
      );
      if (getFile != null) {
        setState(() {
          file = getFile;
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }*/

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
                'Employee Absent Attendance',
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
                    child: DropdownButtonFormField(
                      hint: const Text(
                        'Jenis Ketidakhadiran',
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text('Sakit'),
                          value: 'Sakit',
                        ),
                        DropdownMenuItem(
                          child : Text('Izin'),
                          value : 'Izin',
                        ),
                        DropdownMenuItem(
                          child: Text('Cuti'),
                          value: 'Cuti',
                        ),
                      ],
                      onChanged: (val) {},
                      validator: (Object? val){
                        if (val == null) {
                          return 'Mohon Pilih Alasan';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
            Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
              child: SizedBox(
                child: Text(
                  "Detail Information",
                  textAlign: TextAlign.center,
                  style: kSmallBook,
                ),
              ),
            ),
            const Divider(
              color: Colors.black38,
              height: 20,
              thickness: 1,
              indent: 4,
              endIndent: 4,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Text(
                "Attachments:",
                style: kMediumBook,
              ),
            ),
            kSmallSpacing,
            Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: SizedBox(
              height: 185,
                width: 10,
                child: InkWell(
                  onTap: _pickFile,
                  child: Visibility(
                    visible: file == null,
                    replacement: SizedBox(
                      width: 180,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.file(File(file?.path ?? '')),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 180,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.attach_file_rounded),
                            kTinySpacing,
                            Text('Attach File')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ),
            ),
            kSmallSpacing,
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: SizedBox(
                height: 39,
                width: 10,
                  child: ElevatedButton(
                      onPressed: _pickFile,
                      child: Text(
                        "Absent Attendance"
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