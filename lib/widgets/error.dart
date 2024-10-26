import 'package:flutter/material.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/dialog.dart';

class AppError {
  late BuildContext context;
  static final AppError _appError = AppError._internal();

  factory AppError() {
    return _appError;
  }

  AppError._internal();

  static AppError of(BuildContext context) {
    AppError appError = AppError();
    appError.context = context;
    return appError;
  }

  Future<void> show({String? message, String? title}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AppDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Terjadi kesalahan',
                style: kLargeHeavy,
              ),
              kSmallSpacing,
              Text(
                message ?? '',
                style: kMediumMedium,
              ),
            ],
          ),
          confirmText: 'Okay',
          confirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
