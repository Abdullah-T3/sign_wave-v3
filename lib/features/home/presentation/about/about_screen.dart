import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/Responsive/enums/device_type.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Modern Header Section
                    Container(
                      margin: EdgeInsets.all(_getResponsiveMargin(deviceInfo)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          _getResponsiveBorderRadius(deviceInfo),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          _getResponsivePadding(deviceInfo),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                _getResponsiveLogoPadding(deviceInfo),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  _getResponsiveBorderRadius(deviceInfo),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: _getResponsiveLogoSize(deviceInfo),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            Text(
                              "Sign Wave Translator",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                fontSize: _getResponsiveFontSize(
                                  deviceInfo,
                                  0.06,
                                ),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.01),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: _getResponsiveHorizontalPadding(
                                  deviceInfo,
                                ),
                                vertical: _getResponsiveVerticalPadding(
                                  deviceInfo,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                context.tr("app_version"),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontSize: _getResponsiveFontSize(
                                    deviceInfo,
                                    0.04,
                                  ),
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Content Sections
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getResponsiveContentPadding(deviceInfo),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // About App Section
                          _buildModernSection(
                            title: context.tr("about_app"),
                            icon: Icons.info_outline,
                            context: context,
                            deviceInfo: deviceInfo,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildDescriptionText(
                                  context.tr("about_app_description_1"),
                                  context,
                                  deviceInfo,
                                ),
                                SizedBox(
                                  height: _getResponsiveSpacing(
                                    deviceInfo,
                                    0.015,
                                  ),
                                ),
                                _buildDescriptionText(
                                  context.tr("about_app_description_2"),
                                  context,
                                  deviceInfo,
                                ),
                                SizedBox(
                                  height: _getResponsiveSpacing(
                                    deviceInfo,
                                    0.015,
                                  ),
                                ),
                                _buildDescriptionText(
                                  context.tr("about_app_description_3"),
                                  context,
                                  deviceInfo,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: _getResponsiveSpacing(deviceInfo, 0.03),
                          ),

                          // Features Section
                          _buildModernSection(
                            title: context.tr("features"),
                            icon: Icons.star_outline,
                            context: context,
                            deviceInfo: deviceInfo,
                            child: _buildResponsiveFeaturesGrid(
                              context,
                              deviceInfo,
                            ),
                          ),

                          SizedBox(
                            height: _getResponsiveSpacing(deviceInfo, 0.03),
                          ),

                          // Contact Section
                          _buildModernSection(
                            title: context.tr("contact_us"),
                            icon: Icons.contact_mail_outlined,
                            context: context,
                            deviceInfo: deviceInfo,
                            child: Container(
                              padding: EdgeInsets.all(
                                _getResponsiveFeaturePadding(deviceInfo),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  _getResponsiveBorderRadius(deviceInfo),
                                ),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.2),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.5,
                                    fontSize: _getResponsiveFontSize(
                                      deviceInfo,
                                      0.04,
                                    ),
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${context.tr("contact_us_description")} ",
                                    ),
                                    TextSpan(
                                      text: "eng.abdullahahmed59@gmail.com",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                        fontSize: _getResponsiveFontSize(
                                          deviceInfo,
                                          0.04,
                                        ),
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(
                                                Uri.parse(
                                                  'mailto:eng.abdullahahmed59@gmail.com',
                                                ),
                                              );
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: _getResponsiveSpacing(deviceInfo, 0.04),
                          ),

                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: _getResponsiveHorizontalPadding(
                                  deviceInfo,
                                ),
                                vertical: _getResponsiveVerticalPadding(
                                  deviceInfo,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                  _getResponsiveBorderRadius(deviceInfo),
                                ),
                              ),
                              child: Text(
                                context.tr("copyright"),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                  fontSize: _getResponsiveFontSize(
                                    deviceInfo,
                                    0.035,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: _getResponsiveSpacing(deviceInfo, 0.025),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernSection({
    required String title,
    required IconData icon,
    required Widget child,
    required BuildContext context,
    DeviceInfo? deviceInfo,
  }) {
    return Container(
      padding: EdgeInsets.all(_getResponsiveSectionPadding(deviceInfo)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
          _getResponsiveBorderRadius(deviceInfo),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(_getResponsiveIconPadding(deviceInfo)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: _getResponsiveIconSize(deviceInfo),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDescriptionText(
    String text,
    BuildContext context,
    DeviceInfo? deviceInfo,
  ) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        height: 1.5,
        fontSize: _getResponsiveFontSize(deviceInfo, 0.04),
      ),
    );
  }

  Widget _buildModernFeatureItem(
    String text,
    IconData icon,
    BuildContext context,
    DeviceInfo? deviceInfo,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: _getResponsiveSpacing(deviceInfo, 0.015)),
      padding: EdgeInsets.all(_getResponsiveFeaturePadding(deviceInfo)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(
          _getResponsiveBorderRadius(deviceInfo),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_getResponsiveIconPadding(deviceInfo)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: _getResponsiveFeatureIconSize(deviceInfo),
            ),
          ),
          SizedBox(width: _getResponsiveSpacing(deviceInfo, 0.04)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: _getResponsiveFontSize(deviceInfo, 0.04),
              ),
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: _getResponsiveFeatureIconSize(deviceInfo),
          ),
        ],
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveMargin(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 16;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 32;
    }
  }

  double _getResponsivePadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 20;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.06;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.04;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.03;
    }
  }

  double _getResponsiveBorderRadius(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 20;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 28;
    }
  }

  double _getResponsiveLogoPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 16;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 20;
      case DeviceType.desktop:
        return 24;
    }
  }

  double _getResponsiveLogoSize(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 100;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenHeight * 0.12;
      case DeviceType.tablet:
        return deviceInfo.screenHeight * 0.15;
      case DeviceType.desktop:
        return deviceInfo.screenHeight * 0.18;
    }
  }

  double _getResponsiveSpacing(DeviceInfo? deviceInfo, double factor) {
    if (deviceInfo == null) return 20;
    return deviceInfo.screenHeight * factor;
  }

  double _getResponsiveFontSize(DeviceInfo? deviceInfo, double factor) {
    if (deviceInfo == null) return 16;
    return deviceInfo.screenWidth * factor;
  }

  double _getResponsiveHorizontalPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 16;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 20;
      case DeviceType.desktop:
        return 24;
    }
  }

  double _getResponsiveVerticalPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 6;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 6;
      case DeviceType.tablet:
        return 8;
      case DeviceType.desktop:
        return 10;
    }
  }

  double _getResponsiveContentPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 20;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 40;
      case DeviceType.desktop:
        return 60;
    }
  }

  double _getResponsiveSectionPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 20;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 28;
    }
  }

  double _getResponsiveIconPadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 8;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 8;
      case DeviceType.tablet:
        return 10;
      case DeviceType.desktop:
        return 12;
    }
  }

  double _getResponsiveIconSize(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 24;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 24;
      case DeviceType.tablet:
        return 28;
      case DeviceType.desktop:
        return 32;
    }
  }

  double _getResponsiveFeaturePadding(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 16;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 18;
      case DeviceType.desktop:
        return 20;
    }
  }

  double _getResponsiveFeatureIconSize(DeviceInfo? deviceInfo) {
    if (deviceInfo == null) return 20;
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 22;
      case DeviceType.desktop:
        return 24;
    }
  }

  Widget _buildResponsiveFeaturesGrid(
    BuildContext context,
    DeviceInfo deviceInfo,
  ) {
    final features = [
      {
        'text': context.tr("feature_realtime_messaging"),
        'icon': Icons.chat_bubble_outline,
      },
      {
        'text': context.tr("feature_sign_language"),
        'icon': Icons.translate_outlined,
      },
      {
        'text': context.tr("feature_user_friendly"),
        'icon': Icons.thumb_up_outlined,
      },
      {
        'text': context.tr("feature_secure_auth"),
        'icon': Icons.security_outlined,
      },
    ];

    if (deviceInfo.deviceType == DeviceType.desktop) {
      // Use a 2x2 grid for desktop
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernFeatureItem(
                  features[0]['text'] as String,
                  features[0]['icon'] as IconData,
                  context,
                  deviceInfo,
                ),
              ),
              SizedBox(width: _getResponsiveSpacing(deviceInfo, 0.02)),
              Expanded(
                child: _buildModernFeatureItem(
                  features[1]['text'] as String,
                  features[1]['icon'] as IconData,
                  context,
                  deviceInfo,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildModernFeatureItem(
                  features[2]['text'] as String,
                  features[2]['icon'] as IconData,
                  context,
                  deviceInfo,
                ),
              ),
              SizedBox(width: _getResponsiveSpacing(deviceInfo, 0.02)),
              Expanded(
                child: _buildModernFeatureItem(
                  features[3]['text'] as String,
                  features[3]['icon'] as IconData,
                  context,
                  deviceInfo,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Use vertical layout for mobile and tablet
      return Column(
        children:
            features
                .map(
                  (feature) => _buildModernFeatureItem(
                    feature['text'] as String,
                    feature['icon'] as IconData,
                    context,
                    deviceInfo,
                  ),
                )
                .toList(),
      );
    }
  }
}
