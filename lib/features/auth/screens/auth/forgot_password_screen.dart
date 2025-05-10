import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';

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
                            color: ColorsManager.primaryGridColor,
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
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade300,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Title: "Reset Password"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.02,
                                child: IconButton(
                                  onPressed: () => getIt<AppRouter>().pop(),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Subtitle: "We'll send you a reset link"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.18,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  "We'll send you a reset link\nto your email",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.05,
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
                                    backgroundColor: Colors.white,
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
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: deviceInfo.screenWidth * 0.04,
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
                                hintText: "Email",
                                focusNode: _emailFocus,
                                validator: _validateEmail,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),

                              SizedBox(height: deviceInfo.screenHeight * 0.03),

                              // Instructions text
                              Text(
                                "Enter the email address associated with your account. We'll send you a link to reset your password.",
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
                                text: 'Send Reset Link',
                                child:
                                    state.status == AuthStatus.loading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          "Send Reset Link",
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),

                              SizedBox(height: deviceInfo.screenHeight * 0.02),

                              // Back to login link
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Remember your password? ",
                                    style: TextStyle(color: Colors.grey[600]),
                                    children: [
                                      TextSpan(
                                        text: "Login",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).primaryColor,
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
