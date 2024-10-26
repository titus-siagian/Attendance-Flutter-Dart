import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/cubit/announcement/announcement_list.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/cubit/auth/device_cubit.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/device.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/pages/announcement/announcement.dart';
import 'package:ess_iris/pages/edit_profile/edit_profile.dart';
import 'package:ess_iris/pages/employees/employees.dart';
import 'package:ess_iris/pages/inbox/inbox.dart';
import 'package:ess_iris/pages/live_attendance/live_attendance.dart';
import 'package:ess_iris/pages/login/login.dart';
import 'package:ess_iris/pages/settings/settings.dart';
import 'package:ess_iris/pages/visit_attendance/visit_attendance.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/response/employee_detail.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/fcm_notification.dart';
import 'package:ess_iris/utils/logger.dart';
import 'package:ess_iris/widgets/avatar.dart';
import 'package:ess_iris/widgets/empty.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/request_attendance.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String currentDeviceId;

  void _visitAttendance() async {
    final user = context.read<AuthCubit>().state.data;
    if (user?.avatarUrl?.isEmpty ?? true) {
      await AppError.of(context).show(
        message: 'Silahkan update foto profile terlebih dahulu',
      );
      Navigator.pushNamed(context, EditProfilePage.routeName);
    } else {
      Navigator.pushNamed(context, VisitAttendancePage.routeName);
    }
  }

  void _liveAttendance() async {
    final user = context.read<AuthCubit>().state.data;
    if (user?.avatarUrl?.isEmpty ?? true) {
      await AppError.of(context).show(
        message: 'Silahkan update foto profile terlebih dahulu',
      );
      Navigator.pushNamed(context, EditProfilePage.routeName);
    } else {
      Navigator.pushNamed(context, LiveAttendancePage.routeName);
    }
  }

  void _toEmployees() {
    Navigator.pushNamed(context, EmployeesPage.routeName);
  }

  void _toInbox() {
    Navigator.pushNamed(context, InboxPage.routeName);
  }

  _requestAttendance() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const RequestAttendanceDialog(),
    );

    if (result is bool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil melakukan request!'),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    final state = context.read<AuthCubit>().state;
    context.read<AnnouncementListCubit>().getAnnouncement(state.data!);
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<AuthCubit>().fetchUser();
    });

    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((value) {
        currentDeviceId = value.androidId;
      });
    } else {
      deviceInfo.iosInfo.then((value) {
        currentDeviceId = value.identifierForVendor;
      });
    }

    // handling notifications
    FCMNotification.of(context).initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, DetailState<User>>(
              listener: (context, state) {
            logger.d('state ${state.status}');
            if (state.status == DetailStateStatus.initial) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            }
            if (state.status == DetailStateStatus.success) {
              if (!(state.data?.active ?? false)) {
                AppError.of(context).show(
                  message: 'Hubungi admin untuk unblock akun',
                );
                Future.delayed(const Duration(seconds: 3), () {
                  context.read<AuthCubit>().logout();
                });
              } else {
                String userId = state.data?.id ?? '';
                context.read<DeviceCubit>().fetchDeviceId(userId);
                _onRefresh();
              }
            }
            if (state.status == DetailStateStatus.failure &&
                state.error?.statusCode == 401) {
              context.read<AuthCubit>().logout();
            }
          }),
          BlocListener<DeviceCubit, DetailState<Device>>(
            listener: (context, state) {
              if (state.status == DetailStateStatus.success) {
                if ((state.data?.deviceId ?? '') != currentDeviceId) {
                  AppError.of(context).show(
                    message: 'Hubungi Admin untuk Register Handphone Baru',
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    context.read<AuthCubit>().logout();
                  });
                }
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: NestedScrollView(
            headerSliverBuilder: (context, onScroll) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildAppBar(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: kDefaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kSmallSpacing,
                        Text(
                          'Announcement',
                          style: kLargeHeavy.copyWith(color: kDarkBlueColor),
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<AnnouncementListCubit, ListState<Announcement>>(
              builder: (BuildContext context, state) {
                if (state.status == ListStateStatus.success) {
                  if (state.data?.isNotEmpty ?? false) {
                    return ListView.builder(
                      itemCount: state.data?.length ?? 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, i) {
                        return _news(state.data![i]);
                      },
                    );
                  }
                  return const AppEmpty();
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildAppBar() {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/svg/bg-red.svg',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: kPageViewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthCubit, DetailState<User>>(
                builder: (context, state) {
                  return _userProfile(user: state.data);
                },
              ),
              kMediumSpacing,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: kWhiteColor,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: _liveAttendance,
                      icon: const Icon(
                        Icons.navigation,
                        color: kPrimaryColor,
                      ),
                      label: Text(
                        'Live Attendance',
                        style: kMediumMedium.copyWith(
                          color: kDarkBlueColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: kWhiteColor,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: _visitAttendance,
                      icon: const Icon(
                        Icons.navigation_outlined,
                        color: kPrimaryColor,
                      ),
                      label: Text(
                        'Visit Attendance',
                        style: kMediumMedium.copyWith(
                          color: kDarkBlueColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              kLargeSpacing,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: kWhiteColor,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: _toInbox,
                      icon: const Icon(
                        Icons.inbox,
                        color: kPrimaryColor,
                      ),
                      label: Text(
                        'Inbox',
                        style: kMediumMedium.copyWith(
                          color: kDarkBlueColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    // child: ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //     primary: kWhiteColor,
                    //     alignment: Alignment.centerLeft,
                    //   ),
                    //   onPressed: _toEmployees,
                    //   icon: const Icon(
                    //     Icons.person,
                    //     color: kPrimaryColor,
                    //   ),
                    //   label: Text(
                    //     'Employees',
                    //     style: kMediumMedium.copyWith(
                    //       color: kDarkBlueColor,
                    //     ),
                    //   ),
                    // ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: kWhiteColor,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: _requestAttendance,
                      icon: const Icon(
                        Icons.not_listed_location_rounded,
                        color: kPrimaryColor,
                      ),
                      label: Text(
                        'Request Attend',
                        style: kMediumMedium.copyWith(
                          color: kDarkBlueColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // kLargeSpacing,
              // Center(
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       primary: kWhiteColor,
              //       alignment: Alignment.centerLeft,
              //     ),
              //     onPressed: _requestAttendance,
              //     icon: const Icon(
              //       Icons.not_listed_location_rounded,
              //       color: kPrimaryColor,
              //     ),
              //     label: Text(
              //       'Request Atttendance',
              //       style: kMediumMedium.copyWith(
              //         color: kDarkBlueColor,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }

  Widget _news(Announcement data) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          AnnouncementPage.routeName,
          arguments: data.id,
        );
      },
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      title: Text(
        data.title ?? '',
        style: kMediumBook.copyWith(color: kDarkBlueColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DateFormat('dd MMMM yyyy')
            .format(data.createdAt ?? DateTime.now()),
        style: kSmallBook.copyWith(color: kGreyColor),
      ),
    );
  }

  SafeArea _userProfile({User? user}) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              radius: 32,
              url: user?.avatarUrl,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user?.name ?? '',
                    style: kLargeHeavy.copyWith(color: kWhiteColor),
                  ),
                  kTinySpacing,
                  user?.departmentId != null
                      ? FutureBuilder<EmployeeDetailResponse>(
                          future: UserRepository()
                              .findDepartment(user?.departmentId ?? ''),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.hasData ? snapshot.data?.name ?? '' : '',
                              style: kMediumMedium.copyWith(color: kWhiteColor),
                            );
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
              icon: const Icon(Icons.settings, color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
