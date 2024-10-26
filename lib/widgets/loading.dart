import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoading {
  late BuildContext context;
  static final AppLoading _appLoading = AppLoading._internal();

  factory AppLoading() {
    return _appLoading;
  }

  AppLoading._internal();

  static AppLoading of(BuildContext context) {
    AppLoading appLoading = AppLoading();
    appLoading.context = context;
    return appLoading;
  }

  show() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const _Loading();
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        child: Lottie.asset('assets/lottie/loading-screen.json'),
      ),
    );
  }
}
