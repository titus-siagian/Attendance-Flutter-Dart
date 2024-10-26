import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/image.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class AttendanceDetailPage extends StatefulWidget {
  static const String routeName = '/attendance-detail';

  final Attendance? attendance;

  const AttendanceDetailPage({Key? key, this.attendance}) : super(key: key);

  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Attendance Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 4,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(
                  widget.attendance?.latitude ?? 0,
                  widget.attendance?.longitude ?? 0,
                ),
                maxZoom: 18,
                zoom: 16.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  attributionBuilder: (_) {
                    return const Text("© OpenStreetMap contributors");
                  },
                ),
                MarkerLayerOptions(markers: [
                  Marker(
                    point: LatLng(
                      widget.attendance?.latitude ?? 0,
                      widget.attendance?.longitude ?? 0,
                    ),
                    builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                        ),
                      );
                    },
                  )
                ]),
              ],
            ),
          ),
          Padding(
            padding: kPageViewPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kLargeSpacing,
                Text(
                  'Foto',
                  style: kMediumMedium.copyWith(color: kDarkBlueColor),
                ),
                kTinySpacing,
                SizedBox(
                  height: 240,
                  child: AppImage(
                    url: widget.attendance?.photoUrl ?? '',
                  ),
                ),
                kLargeSpacing,
                Text(
                  'Tanggal',
                  style: kMediumMedium.copyWith(color: kDarkBlueColor),
                ),
                kTinySpacing,
                Text(
                  DateFormat('dd MMMM yyyy').format(
                    widget.attendance?.createdAt?.toLocal() ?? DateTime.now(),
                  ),
                  style: kMediumBook.copyWith(color: kGreyColor),
                ),
                kLargeSpacing,
                Text(
                  'Tipe',
                  style: kMediumMedium.copyWith(color: kDarkBlueColor),
                ),
                kTinySpacing,
                Text(
                  widget.attendance?.value == AttendanceValue.clockIn
                      ? 'Clock In'
                      : 'Clock Out',
                  style: kMediumBook.copyWith(color: kGreyColor),
                ),
                kLargeSpacing,
                Text(
                  'Alasan',
                  style: kMediumMedium.copyWith(color: kDarkBlueColor),
                ),
                kTinySpacing,
                Text(
                  widget.attendance?.problemName ?? '-',
                  style: kMediumBook.copyWith(color: kGreyColor),
                ),
                kLargeSpacing,
                Text(
                  'Keterangan',
                  style: kMediumMedium.copyWith(color: kDarkBlueColor),
                ),
                kTinySpacing,
                Text(
                  widget.attendance?.description ?? '-',
                  style: kMediumBook.copyWith(color: kGreyColor),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
