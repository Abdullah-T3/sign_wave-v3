import 'package:flutter/material.dart';
import '../Models/device_info.dart';
import '../enums/device_type.dart';

/// Mixin providing responsive helper methods for consistent sizing across screens
mixin ResponsiveMixin {
  /// Get responsive padding based on device type
  double getResponsivePadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.08;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.06;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.04;
    }
  }

  /// Get responsive logo size based on device type
  double getResponsiveLogoSize(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.2;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.15;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.12;
    }
  }

  /// Get responsive icon size based on device type
  double getResponsiveIconSize(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.1;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.08;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.06;
    }
  }

  /// Get responsive spacing based on screen height factor
  double getResponsiveSpacing(DeviceInfo deviceInfo, double factor) {
    return deviceInfo.screenHeight * factor;
  }

  /// Get responsive font size based on screen width factor
  double getResponsiveFontSize(DeviceInfo deviceInfo, double factor) {
    return deviceInfo.screenWidth * factor;
  }

  /// Get responsive border radius based on device type
  double getResponsiveBorderRadius(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 28;
    }
  }

  /// Get responsive horizontal padding based on device type
  double getResponsiveHorizontalPadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 20;
      case DeviceType.desktop:
        return 24;
    }
  }

  /// Get responsive vertical padding based on device type
  double getResponsiveVerticalPadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 6;
      case DeviceType.tablet:
        return 8;
      case DeviceType.desktop:
        return 10;
    }
  }

  /// Get responsive content padding based on device type
  double getResponsiveContentPadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 40;
      case DeviceType.desktop:
        return 60;
    }
  }

  /// Get responsive section padding based on device type
  double getResponsiveSectionPadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 28;
    }
  }

  /// Get responsive icon padding based on device type
  double getResponsiveIconPadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 8;
      case DeviceType.tablet:
        return 10;
      case DeviceType.desktop:
        return 12;
    }
  }

  /// Get responsive feature padding based on device type
  double getResponsiveFeaturePadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 18;
      case DeviceType.desktop:
        return 20;
    }
  }

  /// Get responsive feature icon size based on device type
  double getResponsiveFeatureIconSize(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 22;
      case DeviceType.desktop:
        return 24;
    }
  }

  /// Check if device is in landscape orientation
  bool isLandscape(DeviceInfo deviceInfo) {
    return deviceInfo.orientation == Orientation.landscape;
  }

  /// Check if device is mobile
  bool isMobile(DeviceInfo deviceInfo) {
    return deviceInfo.deviceType == DeviceType.mobile;
  }

  /// Check if device is tablet
  bool isTablet(DeviceInfo deviceInfo) {
    return deviceInfo.deviceType == DeviceType.tablet;
  }

  /// Check if device is desktop
  bool isDesktop(DeviceInfo deviceInfo) {
    return deviceInfo.deviceType == DeviceType.desktop;
  }

  /// Get responsive margin based on device type
  double getResponsiveMargin(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 32;
    }
  }
}
