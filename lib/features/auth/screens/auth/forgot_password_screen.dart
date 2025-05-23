import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/localization/cubit/localization_cubit.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/theming/colors.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import '../../../../../router/app_router.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address (e.g., example@email.com)';
    }
    return null;
  }

  Future<void> handleResetPassword(
    DeviceInfo deviceInfo,
    BuildContext context,
  ) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await getIt<AuthCubit>().sendPasswordReset(emailController.text);
      } catch (e) {
        CherryToastMsgs.CherryToastError(
          info: deviceInfo,
          context: context,
          title: "Error",
          description: "${e.toString()}",
        ).show(context);
      }
    } else {
      print("form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listener: (context, state) {
            if (state.status == AuthStatus.passwordResetEmailSent) {
              CherryToastMsgs.CherryToastSuccess(
                info: deviceInfo,
                context: context,
                title: "Success",
                description:
                    "Password reset email sent. Please check your inbox.",
              ).show(context);
              // Navigate back to login screen after a short delay
              Future.delayed(const Duration(seconds: 2), () {
                getIt<AppRouter>().pushReplacement(const LoginScreen());
              });
            } else if (state.status == AuthStatus.error &&
                state.error != null) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Error",
                description: "${state.error}",
              ).show(context);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Section with Gradient Background
                        Container(
                          width: deviceInfo.screenWidth,
                          height: deviceInfo.screenHeight * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.primary
                                : ColorsManager.primaryGridColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                deviceInfo.screenWidth * 0.1,
                              ),
                              bottomRight: Radius.circular(
                                deviceInfo.screenWidth * 0.1,
                              ),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: Theme.of(context).brightness == Brightness.dark
                                  ? [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                    ]
                                  : [
                                      Colors.blue.shade600,
                                      Colors.blue.shade300,
                                    ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: deviceInfo.screenHeight * 0.03,
                                right: deviceInfo.screenWidth * 0.05,
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          context.read<LocalizationCubit>().state.locale.languageCode.toUpperCase(),
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? Theme.of(context).colorScheme.onSurface
                                              : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => context.read<LocalizationCubit>().toggleLocale(),
                                          icon: Icon(
                                            Icons.language,
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? Theme.of(context).colorScheme.onSurface
                                              : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  context.tr("Reset Password"),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.065,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Subtitle: "We'll send you a reset link"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.19,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  context.tr("We'll send you a reset link"),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.045,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),

                              // "Back to Login" Button
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                right: deviceInfo.screenWidth * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    getIt<AppRouter>().pushReplacement(
                                      const LoginScreen(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.surface
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        deviceInfo.screenWidth * 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: deviceInfo.screenWidth * 0.05,
                                      vertical: deviceInfo.screenHeight * 0.01,
                                    ),
                                    child: Text(
                                      context.tr('login'),
                                      style: TextStyle(
                                        color:  Theme.of(context).brightness == Brightness.dark ? Colors.white :
                                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                        fontSize: deviceInfo.screenWidth * 0.035,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Fields
                        SizedBox(height: deviceInfo.screenHeight * 0.05),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            deviceInfo.screenWidth * 0.05,
                            deviceInfo.screenWidth * 0.05,
                            deviceInfo.screenWidth * 0.05,
                            deviceInfo.screenWidth * 0.01,
                          ),
                          child: Column(
                            children: [
                              // Email field
                              CustomTextField(
                                controller: emailController,
                                hintText: context.tr('email'),
                                focusNode: _emailFocus,
                                validator: _validateEmail,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),

                              SizedBox(height: deviceInfo.screenHeight * 0.03),

                              // Instructions text
                              Text(
                                context.tr("Enter the email address associated with your account. We'll send you a link to reset your password."),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: deviceInfo.screenWidth * 0.04,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: deviceInfo.screenHeight * 0.1),

                              // Reset Password Button
                              CustomButton(
                                onPressed:
                                    () => handleResetPassword(
                                      deviceInfo,
                                      context,
                                    ),
                                text: context.tr('send_reset_link'),
                                child:
                                    state.status == AuthStatus.loading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        :  Text(
                                          context.tr('send_reset_link'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),

                              SizedBox(height: deviceInfo.screenHeight * 0.02),

                              // Back to login link
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: context.tr('back_to_login'),
                                    style: TextStyle(color: Colors.grey[600]),
                                    children: [
                                      TextSpan(
                                        text: context.tr('login'),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {
                                                getIt<AppRouter>()
                                                    .pushReplacement(
                                                      const LoginScreen(),
                                                    );
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
