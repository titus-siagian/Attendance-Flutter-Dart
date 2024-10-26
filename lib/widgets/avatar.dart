import 'package:flutter/material.dart';
import 'package:ess_iris/widgets/image.dart';

class AppAvatar extends StatelessWidget {
  final double? radius;
  final String? url;

  const AppAvatar({Key? key, this.radius = 20, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      width: 2.0 * radius!,
      height: 2.0 * radius!,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: url != null
          ? AppImage(
              url: url,
            )
          : Image.asset('assets/images/default-avatar.png'),
    );
  }
}
