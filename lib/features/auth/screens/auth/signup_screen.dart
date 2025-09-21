import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/enums/device_type.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/login_screen.dart'
    show LoginScreen;
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../../core/common/cherryToast/cherry_toast_msgs.dart';

import '../../../../../router/app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('Please enter your name');
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('Please enter your username');
    }
    return null;
  }

  // Email validation
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
      return context.tr('Please enter your password');
    }
    if (value.length < 6) {
      return context.tr('Password must be at least 6 characters long');
    }
    return null;
  }

  // Phone validation
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('Please enter your phone number');
    }

    final phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return context.tr('Please enter a valid 11-digit Egyptian phone number');
    }
    return null;
  }

  Future<void> handleSignUp(DeviceInfo deviceInfo, BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      await getIt<AuthCubit>().signUp(
        fullName: nameController.text,
        username: usernameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
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
                  log('DEBUG: Signup error received: ${state.error}');
                  CherryToastMsgs.CherryToastError(
                    info: deviceInfo,
                    context: context,
                    title: context.tr('sign_up_failed'),
                    description:
                        state.error != null
                            ? (state.error!.startsWith('error_')
                                ? context.tr(state.error!)
                                : state.error!)
                            : context.tr('error_signup_failed'),
                  ).show(context);
                } else if (state.status == AuthStatus.emailUnverified) {
                  CherryToastMsgs.CherryToastVerified(
                    info: deviceInfo,
                    context: context,
                    title: context.tr('account_created_successfully'),
                    description: context.tr('check_email_verify_account'),
                  ).show(context);
                  getIt<AppRouter>().pushReplacement(const LoginScreen());
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
                              height: _getResponsiveSpacing(deviceInfo, 0.025),
                            ),
                            // Back Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () {
                                  getIt<AppRouter>().pushReplacement(
                                    const LoginScreen(),
                                  );
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(
                                    deviceInfo.deviceType == DeviceType.mobile
                                        ? 8
                                        : 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size:
                                        deviceInfo.deviceType ==
                                                DeviceType.mobile
                                            ? 20
                                            : 22,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.025),
                            ),
                            // App Logo/Icon
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
                                Icons.person_add_outlined,
                                size: _getResponsiveIconSize(deviceInfo),
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Welcome Text
                            Text(
                              context.tr('create_account'),
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
                              context.tr('join_us_journey'),
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
                              height: _getResponsiveSpacing(deviceInfo, 0.05),
                            ),
                            // Name Field
                            CustomTextField(
                              controller: nameController,
                              focusNode: _nameFocus,
                              hintText: context.tr('full_name'),
                              labelText: context.tr('full_name'),
                              validator: _validateName,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            // Username Field
                            CustomTextField(
                              controller: usernameController,
                              hintText: context.tr('username'),
                              labelText: context.tr('username'),
                              focusNode: _usernameFocus,
                              validator: _validateUsername,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.alternate_email_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            // Email Field
                            CustomTextField(
                              controller: emailController,
                              hintText: context.tr('email_address'),
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
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            // Phone Field
                            CustomTextField(
                              controller: phoneController,
                              focusNode: _phoneFocus,
                              validator: _validatePhone,
                              hintText: context.tr('phone_number'),
                              labelText: context.tr('phone'),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            // Password Field
                            CustomTextField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              hintText: context.tr('password'),
                              labelText: context.tr('password'),
                              focusNode: _passwordFocus,
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
                              validator: _validatePassword,
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Sign Up Button
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: getIt<AuthCubit>(),
                              builder: (context, state) {
                                return CustomButton(
                                  onPressed:
                                      () => handleSignUp(deviceInfo, context),
                                  text: context.tr('create_account'),
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
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.tr('Already have an account?')} ',
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
                                      const LoginScreen(),
                                    );
                                  },
                                  child: Text(
                                    context.tr('sign in'),
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
