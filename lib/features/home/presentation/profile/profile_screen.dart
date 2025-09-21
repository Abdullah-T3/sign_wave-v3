// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/common/cherryToast/cherry_toast_msgs.dart';
import 'package:sign_wave_v3/core/common/custom_button.dart';
import 'package:sign_wave_v3/core/common/custom_text_field.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/services/di.dart';
import 'package:sign_wave_v3/features/auth/data/models/user_model.dart';
import 'package:sign_wave_v3/router/app_router.dart';
import 'package:sign_wave_v3/features/auth/screens/auth/login_screen.dart';
import '../../../../core/localization/cubit/localization_cubit.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../home/home_screen.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateTextControllers(UserModel user) {
    _nameController.text = user.fullName;
    _usernameController.text = user.username;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
  }

  Future<void> _updateProfile(UserModel user, DeviceInfo info) async {
    final updatedUser = UserModel(
      uid: user.uid,
      username: _usernameController.text,
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
    );

    await context.read<ProfileCubit>().updateProfile(updatedUser, info);
  }

  Future<void> _signOut() async {
    try {
      await context.read<ProfileCubit>().signOut();
      getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _showDeleteAccountDialog(DeviceInfo deviceInfo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'This action will permanently delete:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildWarningItem('• Your profile and personal data'),
              _buildWarningItem('• All your messages and chat history'),
              _buildWarningItem('• Your contacts and connections'),
              _buildWarningItem('• All app preferences and settings'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  '⚠️ This action cannot be undone!',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount(deviceInfo);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete Account',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      ),
    );
  }

  Future<void> _deleteAccount(DeviceInfo deviceInfo) async {
    try {
      await context.read<ProfileCubit>().deleteAccount();

      CherryToastMsgs.CherryToastSuccess(
        context: context,
        title: 'Account Deleted',
        description: 'Your account has been permanently deleted.',
        info: deviceInfo,
      ).show(context);

      // Navigate to login screen after successful deletion
      Future.delayed(const Duration(seconds: 2), () {
        getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
      });
    } catch (e) {
      CherryToastMsgs.CherryToastError(
        context: context,
        title: 'Deletion Failed',
        description: 'Failed to delete account: ${e.toString()}',
        info: deviceInfo,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadUserData(),
      child: SafeArea(
        child: InfoWidget(
          builder: (context, deviceInfo) {
            return BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state.status == ProfileStatus.loaded &&
                    state.user != null) {
                  _updateTextControllers(state.user!);
                }

                if (state.status == ProfileStatus.error &&
                    state.error != null) {
                  CherryToastMsgs.CherryToastError(
                    info: deviceInfo,
                    context: context,
                    title: "Error",
                    description: state.error!,
                  ).show(context);
                }
              },
              builder: (context, state) {
                final isLoading =
                    state.status == ProfileStatus.loading ||
                    state.status == ProfileStatus.initial ||
                    state.status == ProfileStatus.updating;
                final user = state.user;

                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.background,
                          Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child:
                        isLoading
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.tr('Loading profile...'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : SingleChildScrollView(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Modern Profile Header
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.primary
                                              .withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(
                                      deviceInfo.screenWidth * 0.06,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius:
                                                deviceInfo.screenWidth * 0.12,
                                            backgroundColor: Colors.white
                                                .withOpacity(0.3),
                                            child: Icon(
                                              Icons.person,
                                              size:
                                                  deviceInfo.screenWidth * 0.12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              deviceInfo.screenHeight * 0.02,
                                        ),
                                        Text(
                                          user?.fullName ?? "",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall?.copyWith(
                                            fontSize:
                                                deviceInfo.screenWidth * 0.06,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height:
                                              deviceInfo.screenHeight * 0.01,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "@${user?.username ?? ""}",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              fontSize:
                                                  deviceInfo.screenWidth * 0.04,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: deviceInfo.screenHeight * 0.03,
                                  ),

                                  // Profile Information Section
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.person_outline,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.tr('profile_information'),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        _buildProfileField(
                                          context.tr('name'),
                                          _nameController,
                                          Icons.person_outline,
                                          deviceInfo,
                                          enabled: state.isEditing,
                                          context: context,
                                        ),
                                        _buildProfileField(
                                          context.tr('username'),
                                          _usernameController,
                                          Icons.alternate_email,
                                          deviceInfo,
                                          enabled: state.isEditing,
                                          context: context,
                                        ),
                                        _buildProfileField(
                                          context.tr('phone'),
                                          _phoneController,
                                          Icons.phone_outlined,
                                          deviceInfo,
                                          enabled: state.isEditing,
                                          context: context,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: deviceInfo.screenHeight * 0.03,
                                  ),

                                  // Settings Section
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.settings_outlined,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.tr('settings'),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        _buildModernSettingTile(
                                          icon:
                                              context
                                                          .read<ThemeCubit>()
                                                          .state
                                                          .themeMode ==
                                                      ThemeMode.dark
                                                  ? Icons.dark_mode
                                                  : Icons.light_mode,
                                          title:
                                              context
                                                          .read<ThemeCubit>()
                                                          .state
                                                          .themeMode ==
                                                      ThemeMode.dark
                                                  ? context.tr('dark_mode')
                                                  : context.tr('light_mode'),
                                          subtitle:
                                              context
                                                          .read<ThemeCubit>()
                                                          .state
                                                          .themeMode ==
                                                      ThemeMode.dark
                                                  ? context.tr(
                                                    'Dark theme enabled',
                                                  )
                                                  : context.tr(
                                                    'Light theme enabled',
                                                  ),
                                          value:
                                              context
                                                  .read<ThemeCubit>()
                                                  .state
                                                  .themeMode ==
                                              ThemeMode.dark,
                                          onChanged:
                                              (_) =>
                                                  context
                                                      .read<ThemeCubit>()
                                                      .toggleTheme(),
                                          context: context,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildModernSettingTile(
                                          icon: Icons.language,
                                          title:
                                              context
                                                          .read<
                                                            LocalizationCubit
                                                          >()
                                                          .state
                                                          .locale
                                                          .languageCode ==
                                                      'en'
                                                  ? context.tr('english')
                                                  : context.tr('arabic'),
                                          subtitle:
                                              context
                                                          .read<
                                                            LocalizationCubit
                                                          >()
                                                          .state
                                                          .locale
                                                          .languageCode ==
                                                      'en'
                                                  ? context.tr(
                                                    'English language',
                                                  )
                                                  : context.tr(
                                                    'Arabic language',
                                                  ),
                                          value:
                                              context
                                                  .read<LocalizationCubit>()
                                                  .state
                                                  .locale
                                                  .languageCode ==
                                              'ar',
                                          onChanged:
                                              (_) =>
                                                  context
                                                      .read<LocalizationCubit>()
                                                      .toggleLocale(),
                                          context: context,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: deviceInfo.screenHeight * 0.03,
                                  ),

                                  // Action Buttons Section
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        CustomButton(
                                          onPressed: () async {
                                            if (state.isEditing) {
                                              if (user != null) {
                                                await _updateProfile(
                                                  user,
                                                  deviceInfo,
                                                );
                                                context
                                                    .read<ProfileCubit>()
                                                    .toggleEditMode();
                                                CherryToastMsgs.CherryToastSuccess(
                                                  context: context,
                                                  title: context.tr('success'),
                                                  description: context.tr(
                                                    'successfully updated',
                                                  ),
                                                  info: deviceInfo,
                                                ).show(context);
                                                Hero(
                                                  tag: 'home',
                                                  child: HomeScreen(),
                                                );
                                                getIt<AppRouter>()
                                                    .pushAndRemoveUntil(
                                                      const HomeScreen(),
                                                    );
                                              }
                                            } else {
                                              context
                                                  .read<ProfileCubit>()
                                                  .toggleEditMode();
                                            }
                                          },
                                          text:
                                              state.isEditing
                                                  ? context.tr('save_profile')
                                                  : context.tr('edit_profile'),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.red.withOpacity(0.8),
                                                Colors.red.withOpacity(0.6),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: _signOut,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.logout,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          deviceInfo
                                                              .screenWidth *
                                                          0.02,
                                                    ),
                                                    Text(
                                                      context.tr('sign_out'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Delete Account Button
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.red.withOpacity(0.8),
                                                Colors.red.withOpacity(0.6),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap:
                                                  () =>
                                                      _showDeleteAccountDialog(
                                                        deviceInfo,
                                                      ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          deviceInfo
                                                              .screenWidth *
                                                          0.02,
                                                    ),
                                                    Text(
                                                      'Delete Account',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: deviceInfo.screenHeight * 0.03,
                                  ),

                                  // App Version Footer
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        context.tr('app_version'),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontSize:
                                              deviceInfo.screenWidth * 0.035,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Widget _buildProfileField(
  String label,
  TextEditingController controller,
  IconData icon,
  deviceInfo, {
  bool enabled = false,
  final BuildContext? context,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: deviceInfo.screenHeight * 0.02),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context!).textTheme.bodyMedium?.copyWith(
            fontSize: deviceInfo.screenWidth * 0.04,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: deviceInfo.screenHeight * 0.01),
        CustomTextField(
          controller: controller,
          hintText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          keyboardType:
              label == context.tr('phone') ? TextInputType.phone : null,
          enabled: enabled,
        ),
      ],
    ),
  );
}

Widget _buildModernSettingTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required bool value,
  required Function(bool) onChanged,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}
