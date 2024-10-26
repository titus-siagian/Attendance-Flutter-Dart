import 'package:flutter/material.dart';
import 'package:ess_iris/utils/constant.dart';

class AppEmpty extends StatelessWidget {
  final String? message;

  const AppEmpty({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPageViewPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              message ?? 'Belum ada data',
              style: kMediumHeavy.copyWith(
                color: kDarkBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
