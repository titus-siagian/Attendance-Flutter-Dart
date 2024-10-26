import 'package:flutter/material.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/pages/change_password/change_password.dart';
import 'package:ess_iris/pages/edit_profile/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      if (mounted) {
        setState(() {
          packageInfo = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushNamed(context, EditProfilePage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Ganti Kata sandi'),
            onTap: () {
              Navigator.pushNamed(context, ChangePasswordPage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
          kGiantSpacing,kGiantSpacing,
          Center(
            child: Text(
              'Versi ${packageInfo?.version ?? 0}',
              style: kMediumBook.copyWith(
                color: kDarkBlueColor,
              ),
            ),
          ),
          Center(
            child: Text(
              'appName : ${packageInfo?.appName ?? 0}',
              style: kMediumBook.copyWith(
                color: kDarkBlueColor,
              ),
            ),
          ),
          Center(
            child: Text(
              'packageName : ${packageInfo?.packageName ?? 0}',
              style: kMediumBook.copyWith(
                color: kDarkBlueColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
