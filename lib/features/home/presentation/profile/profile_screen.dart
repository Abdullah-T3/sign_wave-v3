import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/common/cherryToast/CherryToastMsgs.dart';
import 'package:sign_wave_v3/core/common/custom_button.dart';
import 'package:sign_wave_v3/core/common/custom_text_field.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/core/services/di.dart';
import 'package:sign_wave_v3/core/theming/colors.dart';
import 'package:sign_wave_v3/core/theming/styles.dart';
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('error_signing_out') + ': ${e.toString()}'),
        ),
      );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('error') + ': ${state.error}'),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading =
                    state.status == ProfileStatus.loading ||
                    state.status == ProfileStatus.initial ||
                    state.status == ProfileStatus.updating;
                final user = state.user;

                return Scaffold(
                  body:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Header with Gradient
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorsManager.blue,
                                        ColorsManager.lightBlue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      deviceInfo.screenWidth * 0.05,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(
                                    deviceInfo.screenWidth * 0.05,
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: deviceInfo.screenWidth * 0.15,
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        child: Icon(
                                          Icons.person,
                                          size: deviceInfo.screenWidth * 0.15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceInfo.screenHeight * 0.02,
                                      ),
                                      Text(
                                        user?.fullName ?? "",
                                        style: TextStyles.title.copyWith(
                                          fontSize:
                                              deviceInfo.screenWidth * 0.06,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: deviceInfo.screenHeight * 0.01,
                                      ),
                                      Text(
                                        "@${user?.username ?? ""}",
                                        style: TextStyles.body.copyWith(
                                          fontSize:
                                              deviceInfo.screenWidth * 0.04,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.03,
                                ),

                                Text(
                                  context.tr('profile_information'),
                                  style: TextStyles.title.copyWith(
                                    fontSize: deviceInfo.screenWidth * 0.05,
                                    color: ColorsManager.backgroundColor,
                                  ),
                                ),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.02,
                                ),

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

                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.03,
                                ),

                                Text(
                                  context.tr('settings'),
                                  style: TextStyles.title.copyWith(
                                    fontSize: deviceInfo.screenWidth * 0.05,
                                    color: ColorsManager.backgroundColor,
                                  ),
                                ),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.02,
                                ),

                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      context
                                                  .read<ThemeCubit>()
                                                  .state
                                                  .themeMode ==
                                              ThemeMode.dark
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: Text(
                                      context
                                                  .read<ThemeCubit>()
                                                  .state
                                                  .themeMode ==
                                              ThemeMode.dark
                                          ? context.tr('dark_mode')
                                          : context.tr('light_mode'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Switch(
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
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap:
                                        () =>
                                            context
                                                .read<ThemeCubit>()
                                                .toggleTheme(),
                                  ),
                                ),

                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.01,
                                ),

                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.language,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: Text(
                                      context
                                                  .read<LocalizationCubit>()
                                                  .state
                                                  .locale
                                                  .languageCode ==
                                              'en'
                                          ? context.tr('english')
                                          : context.tr('arabic'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Switch(
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
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap:
                                        () =>
                                            context
                                                .read<LocalizationCubit>()
                                                .toggleLocale(),
                                  ),
                                ),

                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.03,
                                ),

                                CustomButton(
                                  onPressed: () async {
                                    if (state.isEditing) {
                                      if (user != null) {
                                        _updateProfile(user, deviceInfo);
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
                                        Hero(tag: 'home', child: HomeScreen());
                                        getIt<AppRouter>().pushAndRemoveUntil(
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
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.02,
                                ),
                                CustomButton(
                                  onPressed: _signOut,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: deviceInfo.screenWidth * 0.02,
                                      ),
                                      Text(
                                        context.tr('sign_out'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.03,
                                ),

                                Center(
                                  child: Text(
                                    context.tr('app_version'),
                                    style: TextStyles.body.copyWith(
                                      fontSize: deviceInfo.screenWidth * 0.035,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
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
          style: TextStyle(
            fontSize: deviceInfo.screenWidth * 0.04,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: deviceInfo.screenHeight * 0.01),
        CustomTextField(
          controller: controller,
          hintText: label,
          prefixIcon: Icon(icon),
          keyboardType:
              label == context!.tr('phone') ? TextInputType.phone : null,
          enabled: enabled,
        ),
      ],
    ),
  );
}
