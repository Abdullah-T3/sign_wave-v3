import 'package:flutter/material.dart';

import '../enums/device_type.dart';

class DeviceInfo {
  final DeviceType deviceType;
  final Orientation orientation;
  final double screenWidth;
  final double screenHeight;
  final double localWidth;
  final double localHeight;

  DeviceInfo(
      {required this.deviceType,
      required this.orientation,
      required this.screenWidth,
      required this.screenHeight,
      required this.localWidth,
      required this.localHeight});
  
}
