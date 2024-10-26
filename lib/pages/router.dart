import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/cubit/announcement/announcement.dart';
import 'package:ess_iris/cubit/announcement/announcement_list.dart';
import 'package:ess_iris/cubit/attendance/attendance.dart';
import 'package:ess_iris/cubit/attendance/attendance_list.dart';
import 'package:ess_iris/cubit/auth/device_cubit.dart';
import 'package:ess_iris/cubit/forgot_password/forgot_password.dart';
import 'package:ess_iris/cubit/inbox/inbox_list.dart';
import 'package:ess_iris/cubit/master_location_list/master_location_list.dart';
import 'package:ess_iris/cubit/question/question.dart';
import 'package:ess_iris/cubit/schedule/schedule_cubit.dart';
import 'package:ess_iris/cubit/track_position/track_position_cubit.dart';
import 'package:ess_iris/cubit/user/user_cubit.dart';
import 'package:ess_iris/cubit/user/user_list.dart';
import 'package:ess_iris/models/attendance.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/pages/announcement/announcement.dart';
import 'package:ess_iris/pages/attendance/attendance.dart';
import 'package:ess_iris/pages/attendance_detail/attendance_detail.dart';
import 'package:ess_iris/pages/change_password/change_password.dart';
import 'package:ess_iris/pages/claim_password/claim_password.dart';
import 'package:ess_iris/pages/edit_profile/edit_profile.dart';
import 'package:ess_iris/pages/employees/employees.dart';
import 'package:ess_iris/pages/employees_detail/employees_detail.dart';
import 'package:ess_iris/pages/inbox/inbox.dart';
import 'package:ess_iris/pages/live_attendance/live_attendance.dart';
import 'package:ess_iris/pages/login/login.dart';
import 'package:ess_iris/pages/settings/settings.dart';
import 'package:ess_iris/pages/visit_attendance/visit_attendance.dart';
import 'package:ess_iris/utils/disable_route_animation.dart';

import 'forgot_password/forgot_password.dart';
import 'home/home.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.routeName:
        return DisableAnimPageRoute(
          builder: (_) => const LoginPage(),
        );
      case HomePage.routeName:
        return DisableAnimPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AnnouncementListCubit(),
              ),
              BlocProvider(
                create: (_) => DeviceCubit(),
              ),
            ],
            child: const HomePage(),
          ),
        );
      case AnnouncementPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AnnouncementCubit(),
            child: AnnouncementPage(
              announcementId: settings.arguments as int,
            ),
          ),
        );
      case EditProfilePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const EditProfilePage(),
        );
      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      case VisitAttendancePage.routeName:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AttendanceListCubit(),
              ),
              BlocProvider(
                create: (_) => ScheduleCubit(),
              ),
            ],
            child: const VisitAttendancePage(),
          ),
        );
      case LiveAttendancePage.routeName:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AttendanceListCubit(),
              ),
              BlocProvider(
                create: (_) => ScheduleCubit(),
              ),
            ],
            child: const LiveAttendancePage(),
          ),
        );
      case AttendancePage.routeName:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TrackPositionCubit()..determinePosition(),
              ),
              BlocProvider(
                create: (_) => AttendanceCubit(),
              ),
              BlocProvider(
                create: (_) => MasterLocationListCubit(),
              ),
              BlocProvider(create: (_) => QuestionCubit()),
            ],
            child: AttendancePage(
              arguments: settings.arguments as AttendancePageArgs,
            ),
          ),
        );
      case EmployeesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UserListCubit()..getUsers(),
            child: const EmployeesPage(),
          ),
        );
      case EmployeesDetailPage.routeName:
        return MaterialPageRoute(
          builder: (_) => EmployeesDetailPage(
            user: settings.arguments as User,
          ),
        );
      case InboxPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => InboxListCubit(),
            child: const InboxPage(),
          ),
        );
      case ForgotPasswordPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordCubit(),
            child: const ForgotPasswordPage(),
          ),
        );
      case ClaimPasswordPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordCubit(),
            child: ClaimPasswordPage(
              claimId: settings.arguments as String?,
            ),
          ),
        );
      case ChangePasswordPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UserCubit(),
            child: const ChangePasswordPage(),
          ),
        );
      case AttendanceDetailPage.routeName:
        return MaterialPageRoute(
          builder: (_) => AttendanceDetailPage(
            attendance: settings.arguments as Attendance?,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
