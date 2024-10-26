import 'dart:io';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/cubit/attendance/attendance.dart';
import 'package:ess_iris/cubit/master_location_list/master_location_list.dart';
import 'package:ess_iris/cubit/question/question.dart';
import 'package:ess_iris/cubit/track_position/track_position_cubit.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/models/master_location.dart';
import 'package:ess_iris/models/question.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/logger.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';
import 'package:ess_iris/widgets/question_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class AttendancePageArgs {
  final AttendancePageType type;
  final AttendancePageValue value;

  AttendancePageArgs({
    this.type = AttendancePageType.visit,
    this.value = AttendancePageValue.clockIn,
  });
}

enum AttendancePageType {
  visit,
  live,
}

enum AttendancePageValue {
  clockIn,
  clockOut,
}

class AttendancePage extends StatefulWidget {
  static const String routeName = '/map';

  final AttendancePageArgs? arguments;

  const AttendancePage({Key? key, this.arguments}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _form = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _attendance = Attendance();
  final _mapController = MapController();
  ScrollController? controller;
  List<MasterLocation> _masterLocation = [];
  bool _isFirstTime = true;
  XFile? file;

  showQuestion(Question question) async {
    final result = await showDialog(
      context: context,
      builder: (_) {
        return QuestionModal(
          question: question,
        );
      },
    );

    if (result is bool) {
      context
          .read<AttendanceCubit>()
          .addAttendance(_attendance, file: File(file!.path));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'scroll',
      ]);
    });
    super.initState();
  }

  _pickImage() async {
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
  }

  _onSubmit() {
    if (widget.arguments?.type == AttendancePageType.live) {
      if (_masterLocation.isNotEmpty) {
        MasterLocation location = _masterLocation.first;
        // distance in meter
        double distance = Geolocator.distanceBetween(
          location.latitude ?? 0,
          location.longitude ?? 0,
          _attendance.latitude ?? 0,
          _attendance.longitude ?? 0,
        );
        logger.d("distance $distance");
        if (distance < (location.radius ?? 0)) {
          _attendance.masterLocationId = location.id;
        } else {
          AppError.of(context).show(
            message: 'Terlalu jauh pada area check point',
          );
          return;
        }
      } else {
        AppError.of(context).show(
          message: 'Tidak dapat menemukan check point terdekat',
        );
        return;
      }
    }
    if (_form.currentState!.validate() && file != null) {
      _form.currentState!.save();
      _attendance.type = widget.arguments?.type == AttendancePageType.visit
          ? AttendanceType.visit
          : AttendanceType.live;
      _attendance.value = widget.arguments?.value == AttendancePageValue.clockIn
          ? AttendanceValue.clockIn
          : AttendanceValue.clockOut;
      FocusScope.of(context).unfocus();
      if (_attendance.type == AttendanceType.live) {
        context.read<QuestionCubit>().getQuestion();
      } else {
        context
            .read<AttendanceCubit>()
            .addAttendance(_attendance, file: File(file!.path));
      }
    } else {
      AppError.of(context).show(
        message: file == null
            ? 'Mohon masukkan foto terlebih dahulu'
            : 'Mohon masukkan keterangan terlebih dahulu',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(DateFormat('HH:mm').format(DateTime.now()));
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<TrackPositionCubit>().determinePosition();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<QuestionCubit, DetailState<Question>>(
            listenWhen: (prev, curr) {
              if (prev.status == DetailStateStatus.loading) {
                Navigator.pop(context);
              }
              return true;
            },
            listener: (context, state) {
              if (state.status == DetailStateStatus.loading) {
                AppLoading.of(context).show();
              }
              if (state.status == DetailStateStatus.success) {
                if (state.data != null) {
                  showQuestion(state.data!);
                }
              }
              if (state.status == DetailStateStatus.failure) {
                AppError.of(context).show(message: state.error?.message ?? '');
              }
            },
          ),
          BlocListener<MasterLocationListCubit, ListState<MasterLocation>>(
            listener: (context, state) {
              if (state.status == ListStateStatus.success &&
                  (state.data?.isNotEmpty ?? false)) {
                setState(() {
                  _masterLocation = state.data ?? [];
                });
              }
            },
          ),
          BlocListener<AttendanceCubit, DetailState<Attendance>>(
            listenWhen: (prev, curr) {
              if (prev.status == DetailStateStatus.loading) {
                Navigator.pop(context);
              }
              return true;
            },
            listener: (context, state) {
              if (state.status == DetailStateStatus.loading) {
                AppLoading.of(context).show();
              }
              if (state.status == DetailStateStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil!'),
                  ),
                );
                Navigator.pop(context, true);
              }
              if (state.status == DetailStateStatus.failure) {
                AppError.of(context).show(
                  message: state.error?.message ?? '',
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: _buildContent(),
            ),
            Padding(
              padding: kPageViewPadding,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 0),
                ),
                onPressed: _onSubmit,
                // child: Text(
                //   widget.arguments?.value == AttendancePageValue.clockIn
                //       ? 'Clock In'
                //       : 'Clock Out',
                child: Text(
                  widget.arguments?.value == AttendancePageValue.clockIn &&
                      widget.arguments?.type == AttendancePageType.live
                      ? 'Live Attendance - Clock In'
                      : widget.arguments?.value == AttendancePageValue.clockIn &&
                      widget.arguments?.type == AttendancePageType.visit ||
                      widget.arguments?.value == AttendancePageValue.clockOut &&
                          widget.arguments?.type == AttendancePageType.visit
                      ? widget.arguments?.value == AttendancePageValue.clockIn &&
                      widget.arguments?.type == AttendancePageType.visit
                      ? 'Visit Attendance - Clock In'
                      : 'Visit Attendance - Clock Out'
                      : 'Live Attendance - Clock Out',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack _buildContent() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: BlocConsumer<TrackPositionCubit, DetailState<Position>>(
            listener: (context, state) {
              if (state.status == DetailStateStatus.success) {
                _attendance.latitude = state.data?.latitude;
                _attendance.longitude = state.data?.longitude;
                if (widget.arguments?.type == AttendancePageType.live &&
                    _isFirstTime) {
                  context.read<MasterLocationListCubit>().getNearestLocation(
                      state.data?.latitude ?? 0, state.data?.longitude ?? 0);
                  _isFirstTime = false;
                }

                Future.delayed(const Duration(milliseconds: 500), () {
                  _mapController.move(
                    LatLng(
                      state.data?.latitude ?? 0,
                      state.data?.longitude ?? 0,
                    ),
                    16,
                  );
                });
              }
            },
            buildWhen: (prev, curr) {
              if (prev.status == DetailStateStatus.success) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state.status == DetailStateStatus.failure) {
                return Padding(
                  padding: kDefaultPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          state.error?.message ?? '',
                          style: kLargeHeavy,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      kMediumSpacing,
                      ElevatedButton(
                        onPressed: () async {
                          if ((state.error?.message ?? '')
                              .contains('fitur lokasi')) {
                            await Geolocator.openLocationSettings();
                          } else {
                            await Geolocator.openAppSettings();
                          }

                          context
                              .read<TrackPositionCubit>()
                              .determinePosition();
                        },
                        child: const Text('Buka pengaturan'),
                      ),
                    ],
                  ),
                );
              }
              if (state.status == DetailStateStatus.success &&
                  !(state.data?.isMocked ?? false)) {
                final position = state.data;
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(
                      position?.latitude ?? 0,
                      position?.longitude ?? 0,
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
                    CircleLayerOptions(
                        circles: _masterLocation
                            .map(
                              (e) => CircleMarker(
                                point: LatLng(
                                  e.latitude ?? 0,
                                  e.longitude ?? 0,
                                ),
                                radius: e.radius ?? 0,
                                useRadiusInMeter: true,
                                color: Colors.blue.withOpacity(0.5),
                              ),
                            )
                            .toList()),
                    MarkerLayerOptions(markers: [
                      Marker(
                        point: LatLng(
                          position?.latitude ?? 0,
                          position?.longitude ?? 0,
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
                );
              }

              if (state.status == DetailStateStatus.success &&
                  (state.data?.isMocked ?? false)) {
                return const Center(
                  child: Text(
                    'Anda terdeteksi menggunakan fake GPS',
                    style: kMediumHeavy,
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.50,
          minChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: DescribedFeatureOverlay(
                      featureId: 'scroll',
                      tapTarget: draggableLine(),
                      description: const Text(
                        'Scroll ke atas untuk melihat\ninformasi lainnya',
                        style: kLargeMedium,
                      ),
                      contentLocation: ContentLocation.above,
                      child: draggableLine(),
                    ),
                  ),
                  _buildAttachment(scrollController),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Container draggableLine() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: kWhiteColor2,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 60,
      height: 4,
    );
  }

  _buildAttachment(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: kPageViewPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail',
            style: kLargeHeavy.copyWith(color: kDarkBlueColor),
          ),
          kMediumSpacing,
          Text(
            'Lampiran',
            style: kMediumMedium.copyWith(
              color: kDarkBlueColor,
            ),
          ),
          kExtraSmallSpacing,
          InkWell(
            onTap: _pickImage,
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
                      Icon(Icons.add_a_photo_rounded),
                      kTinySpacing,
                      Text('Tambah Foto')
                    ],
                  ),
                ),
              ),
            ),
          ),
          kMediumSpacing,
          Form(
            key: _form,
            child: AppInput(
              title: 'Keterangan',
              minLines: 4,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              validator: (val) {
                if (widget.arguments?.type == AttendancePageType.live) {
                  return null;
                }
                if (val?.isEmpty ?? true) {
                  return 'Mohon masukkan keterangan';
                }
                return null;
              },
              onSaved: (val) {
                _attendance.description = val;
              },
            ),
          ),
        ],
      ),
    );
  }
}
