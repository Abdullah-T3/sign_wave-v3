import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Functions/get_device_type.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/localization/cubit/localization_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/theming/colors.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mediaQuery = MediaQuery.of(context);
          final deviceInfo = DeviceInfo(
            orientation: mediaQuery.orientation,
            deviceType: getDeviceType(mediaQuery),
            screenWidth: mediaQuery.size.width,
            screenHeight: mediaQuery.size.height,
            localWidth: constraints.maxWidth,
            localHeight: constraints.maxHeight,
          );
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        focusNode: _emailFocus,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed:
                            () => handleResetPassword(deviceInfo, context),
                        text: 'Reset Password',
                        child: BlocBuilder<AuthCubit, AuthState>(
                          bloc: getIt<AuthCubit>(),
                          builder: (context, state) {
                            if (state.status == AuthStatus.loading) {
                              return CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            }
                            return Text(
                              'Reset Password',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            getIt<AppRouter>().pushReplacement(
                              const LoginScreen(),
                            );
                          },
                          child: Text(
                            'Back to Login',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
