import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart' show TextStyles;
import '../../../../core/localization/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: deviceInfo.screenWidth,
                      height: deviceInfo.screenHeight * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorsManager.blue, ColorsManager.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            deviceInfo.screenWidth * 0.1,
                          ),
                          topRight: Radius.circular(
                            deviceInfo.screenWidth * 0.1,
                          ),
                          bottomLeft: Radius.circular(
                            deviceInfo.screenWidth * 0.1,
                          ),
                          bottomRight: Radius.circular(
                            deviceInfo.screenWidth * 0.1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logo.png",
                            height: deviceInfo.screenHeight * 0.15,
                          ),
                          SizedBox(height: deviceInfo.screenHeight * 0.02),
                          Text(
                            "Sign Wave Translator",
                            style: TextStyles.title.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.06,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: deviceInfo.screenHeight * 0.01),
                          Text(
                            context.tr("app_version"),
                            style: TextStyles.body.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("about_app"),
                          style: TextStyles.title.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.05,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.01),
                        Text(
                          context.tr("about_app_description_1"),
                          style: TextStyles.body.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.04,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.01),
                        Text(
                          context.tr("about_app_description_2"),
                          style: TextStyles.body.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.04,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.01),
                        Text(
                          context.tr("about_app_description_3"),
                          style: TextStyles.body.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.04,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.02),
                        Text(
                          context.tr("features"),
                          style: TextStyles.title.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.05,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.01),
                        _buildFeatureItem(
                          context.tr("feature_realtime_messaging"),
                          deviceInfo,
                          context,
                        ),
                        _buildFeatureItem(
                          context.tr("feature_sign_language"),
                          deviceInfo,
                          context,
                        ),
                        _buildFeatureItem(
                          context.tr("feature_user_friendly"),
                          deviceInfo,
                          context,
                        ),
                        _buildFeatureItem(
                          context.tr("feature_secure_auth"),
                          deviceInfo,
                          context,
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.02),
                        Text(
                          context.tr("contact_us"),
                          style: TextStyles.title.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.05,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : ColorsManager.backgroundColor,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.01),
                        RichText(
                          text: TextSpan(
                            style: TextStyles.body.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.04,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : ColorsManager.backgroundColor,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    context.tr("contact_us_description") + " ",
                              ),
                              TextSpan(
                                text: "eng.abdullahahmed59@gmail.com",
                                style: TextStyles.body.copyWith(
                                  fontSize: deviceInfo.screenWidth * 0.04,
                                  color: ColorsManager.blue,
                                  decoration: TextDecoration.underline,
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
                        SizedBox(height: deviceInfo.screenHeight * 0.03),
                        Center(
                          child: Text(
                            context.tr("copyright"),
                            style: TextStyles.body.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.035,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white60
                                      : ColorsManager.backgroundColor
                                          .withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: deviceInfo.screenHeight * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(String text, deviceInfo, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceInfo.screenHeight * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: ColorsManager.blue,
            size: deviceInfo.screenWidth * 0.05,
          ),
          SizedBox(width: deviceInfo.screenWidth * 0.02),
          Expanded(
            child: Text(
              text,
              style: TextStyles.body.copyWith(
                fontSize: deviceInfo.screenWidth * 0.04,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : ColorsManager.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
