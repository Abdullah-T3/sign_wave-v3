import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart' show TextStyles;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: deviceInfo.screenHeight * 0.15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Sign Wave Translator",
                    style: TextStyles.title.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.06,
                      color: ColorsManager.backgroundColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Version 1.0.0",
                    style: TextStyles.body.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.04,
                      color: ColorsManager.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "About the App",
                    style: TextStyles.title.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.05,
                      color: ColorsManager.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign Wave Translator is a real-time sign language translation application that helps bridge communication gaps between the deaf community and others. The app allows users to communicate through text messages and provides sign language translation features.",
                    style: TextStyles.body.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.04,
                      color: ColorsManager.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Features",
                    style: TextStyles.title.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.05,
                      color: ColorsManager.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem("Real-time messaging", deviceInfo),
                  _buildFeatureItem("Sign language translation", deviceInfo),
                  _buildFeatureItem("User-friendly interface", deviceInfo),
                  _buildFeatureItem("Secure authentication", deviceInfo),
                  const SizedBox(height: 24),
                  Text(
                    "Contact Us",
                    style: TextStyles.title.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.05,
                    ),
                  ),
                  const SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      style: TextStyles.body.copyWith(
                        fontSize: deviceInfo.screenWidth * 0.04,
                        color: ColorsManager.backgroundColor,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              "For support or feedback, please contact us at ",
                        ),
                        TextSpan(
                          text: "eng.abdullahahmed59@gmail.com",
                          style: TextStyles.body.copyWith(
                            fontSize: deviceInfo.screenWidth * 0.04,
                            color: Colors.blue,
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(String text, deviceInfo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyles.body.copyWith(
                fontSize: deviceInfo.screenWidth * 0.04,
                color: ColorsManager.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
