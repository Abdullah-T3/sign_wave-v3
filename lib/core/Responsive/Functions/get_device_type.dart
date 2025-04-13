import 'package:flutter/material.dart';

import '../enums/device_type.dart';

DeviceType getDeviceType(MediaQueryData mediaQuery) {
  Orientation orientation = mediaQuery.orientation;
  double width = 0;
  if (orientation == Orientation.landscape) {
    width = mediaQuery.size.height;
  } else {
    width = mediaQuery.size.width;
  }
  if (width >= 950) {
    return DeviceType.desktop;
  }
  if (width >= 600) {
    return DeviceType.tablet;
  }
  return DeviceType.mobile;
}