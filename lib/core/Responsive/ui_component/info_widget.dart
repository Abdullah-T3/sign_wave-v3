import 'package:flutter/material.dart';

import '../Functions/get_device_type.dart';
import '../Models/device_info.dart';

class InfoWidget extends StatelessWidget {

  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;

  const InfoWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var mediaQuery = MediaQuery.of(context);
      var deviceInfo = DeviceInfo(
        orientation: mediaQuery.orientation,
        deviceType: getDeviceType(mediaQuery),
        screenWidth: mediaQuery.size.width,
        screenHeight: mediaQuery.size.height,
        localWidth: constraints.maxWidth,
        localHeight: constraints.maxHeight,
      );

      return builder(context, deviceInfo);
    });
  }
}