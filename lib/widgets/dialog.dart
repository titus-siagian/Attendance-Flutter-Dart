import 'package:flutter/material.dart';
import 'package:ess_iris/utils/constant.dart';

class AppDialog extends StatelessWidget {
  final Widget? child;
  final String? confirmText;
  final Function()? confirm;
  final String? cancelText;
  final Function()? cancel;

  const AppDialog({
    Key? key,
    this.child,
    this.confirmText,
    this.confirm,
    this.cancelText,
    this.cancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child != null) child!,
            kLargeSpacing,
            _actions(),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Row _actions() {
    return Row(
      children: [
        Visibility(
          visible: cancel != null,
          child: Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kWhiteColor2,
              ),
              onPressed: cancel,
              child: Text(
                cancelText ?? '',
                style: kMediumHeavy.copyWith(color: kGreyColor2),
              ),
            ),
          ),
        ),
        Visibility(
          visible: cancel != null && confirm != null,
          child: const SizedBox(
            width: 8,
          ),
        ),
        Visibility(
          visible: confirm != null,
          child: Expanded(
            child: ElevatedButton(
              onPressed: confirm,
              child: Text(
                confirmText ?? '',
                style: kMediumHeavy,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
