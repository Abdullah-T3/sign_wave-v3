import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/enums/device_type.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/forgot_password_screen.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';
import 'package:sign_wave_v3/features/home/presentation/home/home_screen.dart';
import '../../../../core/common/cherryToast/cherry_toast_msgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';

import 'signup_screen.dart';
import '../../../../../router/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('Please enter your email');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.tr('Please enter a valid email address');
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('Please enter a password');
    }
    if (value.length < 6) {
      return context.tr('Password must be at least 6 characters long');
    }
    return null;
  }

  Future<void> handleSignIn(DeviceInfo deviceInfo, BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      await getIt<AuthCubit>().signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  // Responsive helper methods
  double _getResponsivePadding(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.08;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.06;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.04;
    }
  }

  double _getResponsiveLogoSize(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.2;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.15;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.12;
    }
  }

  double _getResponsiveIconSize(DeviceInfo deviceInfo) {
    switch (deviceInfo.deviceType) {
      case DeviceType.mobile:
        return deviceInfo.screenWidth * 0.1;
      case DeviceType.tablet:
        return deviceInfo.screenWidth * 0.08;
      case DeviceType.desktop:
        return deviceInfo.screenWidth * 0.06;
    }
  }

  double _getResponsiveSpacing(DeviceInfo deviceInfo, double factor) {
    return deviceInfo.screenHeight * factor;
  }

  double _getResponsiveFontSize(DeviceInfo deviceInfo, double factor) {
    return deviceInfo.screenWidth * factor;
  }

  @override
  Widget build(BuildContext context) {
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
        child: InfoWidget(
          builder: (context, deviceInfo) {
            return BlocListener<AuthCubit, AuthState>(
              bloc: getIt<AuthCubit>(),
              listener: (context, state) {
                if (state.status == AuthStatus.error) {
                  CherryToastMsgs.CherryToastError(
                    info: deviceInfo,
                    context: context,
                    title: context.tr('login'),
                    description:
                        state.error != null
                            ? (state.error!.startsWith('error_')
                                ? context.tr(state.error!)
                                : state.error!)
                            : context.tr('error'),
                  ).show(context);
                } else if (state.status == AuthStatus.emailUnverified) {
                  CherryToastMsgs.CherryToastVerified(
                    info: deviceInfo,
                    context: context,
                    title: context.tr('error'),
                    description:
                        state.error != null
                            ? (state.error!.startsWith('error_')
                                ? context.tr(state.error!)
                                : state.error!)
                            : context.tr('error_email_not_verified'),
                  ).show(context);
                }
                if (state.status == AuthStatus.authenticated) {
                  getIt<AppRouter>().pushAndRemoveUntil(HomeScreen());
                }
              },
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getResponsivePadding(deviceInfo),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.05),
                            ),
                            Container(
                              height: _getResponsiveLogoSize(deviceInfo),
                              width: _getResponsiveLogoSize(deviceInfo),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  deviceInfo.deviceType == DeviceType.mobile
                                      ? 20
                                      : 24,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                size: _getResponsiveIconSize(deviceInfo),
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Welcome Text
                            Text(
                              context.tr('Welcome Back to Sign Wave'),
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: _getResponsiveFontSize(
                                  deviceInfo,
                                  0.06,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.01),
                            ),
                            Text(
                              context.tr('sign_in_to_continue'),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.7),
                                fontSize: _getResponsiveFontSize(
                                  deviceInfo,
                                  0.04,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.06),
                            ),
                            // Email Field
                            CustomTextField(
                              controller: emailController,
                              hintText: context.tr('email'),
                              labelText: context.tr('email'),
                              focusNode: _emailFocus,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.025),
                            ),
                            // Password Field
                            CustomTextField(
                              controller: passwordController,
                              focusNode: _passwordFocus,
                              validator: _validatePassword,
                              hintText: context.tr('password'),
                              labelText: context.tr('password'),
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.015),
                            ),
                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  getIt<AppRouter>().pushReplacement(
                                    const ForgotPasswordScreen(),
                                  );
                                },
                                child: Text(
                                  context.tr('forgot password?'),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _getResponsiveFontSize(
                                      deviceInfo,
                                      0.035,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Login Button
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: getIt<AuthCubit>(),
                              builder: (context, state) {
                                return CustomButton(
                                  onPressed:
                                      () => handleSignIn(deviceInfo, context),
                                  text: context.tr('sign in'),
                                  isLoading: state.status == AuthStatus.loading,
                                );
                              },
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _getResponsiveSpacing(
                                      deviceInfo,
                                      0.02,
                                    ),
                                  ),
                                  child: Text(
                                    context.tr('OR'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                      fontSize: _getResponsiveFontSize(
                                        deviceInfo,
                                        0.035,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.tr("don't have an account?")} ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onBackground.withOpacity(0.7),
                                    fontSize: _getResponsiveFontSize(
                                      deviceInfo,
                                      0.035,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    getIt<AppRouter>().pushReplacement(
                                      const SignupScreen(),
                                    );
                                  },
                                  child: Text(
                                    context.tr('sign up'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: _getResponsiveFontSize(
                                        deviceInfo,
                                        0.035,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.05),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
