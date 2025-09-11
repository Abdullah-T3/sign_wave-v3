import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/localization/cubit/localization_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/login_screen.dart'
    show LoginScreen;
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/theming/colors.dart';
import '../../../../../core/Responsive/Functions/get_device_type.dart';
import '../../../../../core/Responsive/Models/device_info.dart';

import '../../../home/presentation/home/home_screen.dart';
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

  Future<void> handleSignUp() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await getIt<AuthCubit>().signUp(
          fullName: nameController.text,
          username: usernameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
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
                        'Sign up',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: nameController,
                        focusNode: _nameFocus,
                        hintText: 'Name',
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: usernameController,
                        hintText: 'Username',
                        focusNode: _usernameFocus,
                        validator: _validateUsername,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        focusNode: _emailFocus,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: phoneController,
                        focusNode: _phoneFocus,
                        validator: _validatePhone,
                        hintText: 'Phone',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        hintText: 'Password',
                        focusNode: _passwordFocus,
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
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: handleSignUp,
                        text: 'Sign Up',
                        child: BlocBuilder<AuthCubit, AuthState>(
                          bloc: getIt<AuthCubit>(),
                          builder: (context, state) {
                            if (state.status == AuthStatus.loading) {
                              return CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            }
                            return Text(
                              'Sign Up',
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
                            'Already have an account? Login',
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
