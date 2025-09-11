import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/localization/cubit/localization_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/forgot_password_screen.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/theming/colors.dart';
import '../../../../../core/Responsive/Functions/get_device_type.dart';

import '../../../home/presentation/home/home_screen.dart';
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
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return context.tr('Password must be at least 6 characters long');
    }
    return null;
  }

  Future<void> handleSignIn(DeviceInfo deviceInfo, BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await getIt<AuthCubit>().signIn(
          email: emailController.text,
          password: passwordController.text,
        );
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
                        'Chat',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Username',
                        focusNode: _emailFocus,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: passwordController,
                        focusNode: _passwordFocus,
                        validator: _validatePassword,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: () => handleSignIn(deviceInfo, context),
                        text: 'Login',
                        child: BlocBuilder<AuthCubit, AuthState>(
                          bloc: getIt<AuthCubit>(),
                          builder: (context, state) {
                            if (state.status == AuthStatus.loading) {
                              return CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            }
                            return Text(
                              'Login',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              getIt<AppRouter>().pushReplacement(
                                const ForgotPasswordScreen(),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () {
                              getIt<AppRouter>().pushReplacement(
                                const SignupScreen(),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
