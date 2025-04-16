import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/login_screen.dart'
    show LoginScreen;

import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/theming/colors.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';
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
      return "Please enter your full name";
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username";
    }
    return null;
  }

  // Email validation
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

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Phone validation
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
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
  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              getIt<AppRouter>().pushAndRemoveUntil(const HomeScreen());
            } else if (state.status == AuthStatus.error &&
                state.error != null) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Error",
                description: state.error!,
              ).show(context);
            } else if (state.status == AuthStatus.emailUnverified) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Error",
                description: "Please verify your email first",
              ).show(context);
            }
            getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
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
                              // Title: "Sign Up"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Subtitle: "Welcome Back to Sign Wave"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.18,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  "Welcome Back to\nSign Wave",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceInfo.screenWidth * 0.05,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),

                              // "Sign In" Button
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
                                        deviceInfo.screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: deviceInfo.screenWidth * 0.05,
                                      vertical: deviceInfo.screenHeight * 0.01,
                                    ),
                                    child: Text(
                                      "Sign In",
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
                              CustomTextField(
                                controller: nameController,
                                focusNode: _nameFocus,
                                hintText: "Full Name",
                                validator: _validateName,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.015),
                              CustomTextField(
                                controller: usernameController,
                                hintText: "Username",
                                focusNode: _usernameFocus,
                                validator: _validateUsername,
                                prefixIcon: const Icon(Icons.alternate_email),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.015),
                              CustomTextField(
                                controller: emailController,
                                hintText: "Email",
                                focusNode: _emailFocus,
                                validator: _validateEmail,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.015),
                              CustomTextField(
                                controller: phoneController,
                                focusNode: _phoneFocus,
                                validator: _validatePhone,
                                hintText: "Phone Number",
                                prefixIcon: const Icon(Icons.phone_outlined),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.015),
                              CustomTextField(
                                controller: passwordController,
                                obscureText: !_isPasswordVisible,
                                hintText: "Password",
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
                                  ),
                                ),
                                validator: _validatePassword,
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.05),
                              CustomButton(
                                onPressed: handleSignUp,
                                text: "Create Account",
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.05),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Already have an account?  ",
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
                                                Navigator.pop(context);
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
