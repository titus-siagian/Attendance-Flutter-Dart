import 'package:flutter/material.dart';

class DisableAnimPageRoute extends MaterialPageRoute {
  DisableAnimPageRoute({builder, settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
