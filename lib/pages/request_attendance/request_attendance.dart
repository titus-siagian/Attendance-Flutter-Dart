import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:hr_mobile/pages/request2_attendance/request_attend.dart';
import 'package:hr_mobile/services/request/request_attendance.dart';
import '../absent_attendance/absent_attendance.dart';

class RequestPage extends StatefulWidget{
  static const String routeName = '/request-attendance';
  
  const RequestPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>{
  bool showDateError = false;
  AttendanceRequest request = AttendanceRequest();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'scroll',
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Request / Absent Attendance"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Absent"),
              Tab(text: "Request"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AbsentPage(),
            RequestAttendPage(),
          ],
        ),
      ),

  );
}