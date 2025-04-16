import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/forgot_password_screen.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/common/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/services/di.dart';
import '../../../../core/services/fcm_service.dart' show sendNotification;
import '../../../../core/theming/colors.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';
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
  /*************  ✨ Codeium Command ⭐  *************/
  /// Validates the form and if valid, attempts to sign in the user
  /// using the provided email and password. If the sign in fails, it
  /// will show an error toast to the user.
  ///
  /// If the form is invalid, it will print a message to the console.
  /******  fbc7552c-da33-44b2-8a79-bc801e9a81bc  *******/

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
  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listener: (context, state) {
            print("state.status: ${state.status}");
            if (state.status == AuthStatus.authenticated) {
              CherryToastMsgs.CherryToastSuccess(
                info: deviceInfo,
                context: context,
                title: "Success",
                description: "Logged in successfully",
              ).show(context);
              getIt<AppRouter>().pushAndRemoveUntil(const HomeScreen());
            } else if (state.status == AuthStatus.error &&
                state.error != null) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Error",
                description: "${state.error}",
              ).show(context);
            } else if (state.status == AuthStatus.emailUnverified) {
              CherryToastMsgs.CherryToastVerified(
                info: deviceInfo,
                context: context,
                title: "Verification Required",
                description: "Please verify your email first",
              ).show(context);
            } else if (state.status == AuthStatus.passwordResetEmailSent) {
              CherryToastMsgs.CherryToastSuccess(
                info: deviceInfo,
                context: context,
                title: "Success",
                description: "Password reset email sent",
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
                              // Title: "Sign In"
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                left: deviceInfo.screenWidth * 0.05,
                                child: Text(
                                  "Sign In",
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

                              // "Sign Up" Button
                              Positioned(
                                top: deviceInfo.screenHeight * 0.1,
                                right: deviceInfo.screenWidth * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    getIt<AppRouter>().pushReplacement(
                                      const SignupScreen(),
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
                                      "Sign Up",
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
                                controller: emailController,
                                hintText: "Email",
                                focusNode: _emailFocus,
                                validator: _validateEmail,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.03),
                              // Add this after the password field and before the login button
                              CustomTextField(
                                controller: passwordController,
                                focusNode: _passwordFocus,
                                validator: _validatePassword,
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline),
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
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    getIt<AppRouter>().push(
                                      const ForgotPasswordScreen(),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.1),
                              CustomButton(
                                onPressed:
                                    () => handleSignIn(deviceInfo, context),
                                text: 'Login',
                                child:
                                    state.status == AuthStatus.loading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.02),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account?  ",
                                    style: TextStyle(color: Colors.grey[600]),
                                    children: [
                                      TextSpan(
                                        text: "Sign up",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {
                                                getIt<AppRouter>().push(
                                                  const SignupScreen(),
                                                );
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  await sendNotification(
                                    body: "hi T3mia",
                                    title: "Abdullah Ahmed",
                                    token: getIt<String>(
                                      instanceName: 'firebaseToken',
                                    ),
                                    data: {
                                      "title": "Hello World",
                                      "body": "Hi Abdullah",
                                    },
                                  );
                                },
                                child: Text("Send Notification"),
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
