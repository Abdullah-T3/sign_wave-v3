// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/enums/device_type.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';

import '../../../../core/common/cherryToast/cherry_toast_msgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';

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
      return context.tr('please_enter_email_address');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.tr('please_enter_valid_email_example');
    }
    return null;
  }

  Future<void> handleResetPassword(
    DeviceInfo deviceInfo,
    BuildContext context,
  ) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      await getIt<AuthCubit>().sendPasswordReset(emailController.text);
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
              Theme.of(context).colorScheme.primary.withAlpha(10),
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.secondary.withAlpha(5),
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
                    title: context.tr('error'),
                    description:
                        state.error != null
                            ? (state.error!.startsWith('error_')
                                ? context.tr(state.error!)
                                : state.error!)
                            : context.tr('error_password_reset_failed'),
                  ).show(context);
                } else if (state.status == AuthStatus.passwordResetEmailSent) {
                  CherryToastMsgs.CherryToastSuccess(
                    info: deviceInfo,
                    context: context,
                    title: context.tr('reset_email_sent'),
                    description: context.tr('check_email_reset_instructions'),
                  ).show(context);
                  getIt<AppRouter>().pop();
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
                                    ).colorScheme.surface.withAlpha(80),
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
                            Container(
                              height: _getResponsiveLogoSize(deviceInfo),
                              width: _getResponsiveLogoSize(deviceInfo),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withAlpha(70),
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
                                    ).colorScheme.primary.withAlpha(30),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.lock_reset_outlined,
                                size: _getResponsiveIconSize(deviceInfo),
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            Text(
                              context.tr('forgot password?'),
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: _getResponsiveFontSize(
                                  deviceInfo,
                                  0.06,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.02),
                            ),
                            // Description Text
                            Text(
                              context.tr('dont_worry_reset'),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withAlpha(30),
                                height: 1.5,
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
                              hintText: context.tr('email_address'),
                              labelText: context.tr('email'),
                              focusNode: _emailFocus,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Reset Password Button
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: getIt<AuthCubit>(),
                              builder: (context, state) {
                                return CustomButton(
                                  onPressed:
                                      () => handleResetPassword(
                                        deviceInfo,
                                        context,
                                      ),
                                  text: context.tr('send_reset_link'),
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
                                    ).colorScheme.outline.withAlpha(30),
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface.withAlpha(30),
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
                                    ).colorScheme.outline.withAlpha(30),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _getResponsiveSpacing(deviceInfo, 0.04),
                            ),
                            // Back to Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.tr('remember_password')} ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface.withAlpha(30),
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
