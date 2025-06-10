import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sign_wave_v3/core/services/fcm_service.dart';
import 'package:sign_wave_v3/core/services/zegoCloud_call.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_state.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'core/observer/app_life_cycle_observer.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/cubit/localization_cubit.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/home/data/repo/chat_repository.dart';
import 'core/services/di.dart';

import 'features/home/presentation/home/home_screen.dart';
import 'features/auth/screens/auth/login_screen.dart';
import 'theme/app_theme.dart';
import 'package:zego_uikit/zego_uikit.dart';

Future<void> _initializeApp() async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  await setupServiceLocator();

  getIt.registerSingleton<ThemeCubit>(ThemeCubit(prefs: prefs));
  getIt.registerSingleton<LocalizationCubit>(LocalizationCubit(prefs: prefs));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);
  });

  await _initializeApp().timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception('App initialization timed out'),
  );
  await dotenv.load(fileName: ".env");

  FirebaseMessaging.onBackgroundMessage(
    FcmService.firebaseMessagingBackgroundHandler,
  );
  FcmService.onForgroundMessage();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _lifeCycleObserver;

  @override
  void initState() {
    super.initState();
    _initializeLifecycleObserver();
  }

  void _initializeLifecycleObserver() {
    _lifeCycleObserver = AppLifeCycleObserver(
      userId: '',
      chatRepository: getIt<ChatRepository>(),
    );

    WidgetsBinding.instance.addObserver(_lifeCycleObserver);

    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        _lifeCycleObserver = AppLifeCycleObserver(
          userId: state.user!.uid,
          chatRepository: getIt<ChatRepository>(),
        );
        WidgetsBinding.instance.addObserver(_lifeCycleObserver);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<LocalizationCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, localizationState) {
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp(
                  routes: {'/target': (context) => const HomeScreen()},
                  title: 'Sign Wave Translator',
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,

                  // Theme configuration
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,

                  // Localization configuration
                  locale: localizationState.locale,
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (BuildContext context, Widget? child) {
                    return Stack(
                      children: [
                        child!,
                        ZegoUIKitPrebuiltCallMiniOverlayPage(
                          contextQuery: () {
                            return navigatorKey.currentState!.context;
                          },
                        ),
                      ],
                    );
                  },
                  home: BlocBuilder<AuthCubit, AuthState>(
                    bloc: getIt<AuthCubit>(),
                    builder: (context, state) {
                      if (state.status == AuthStatus.initial) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state.status == AuthStatus.authenticated) {
                        try {
                          onUserLogin(state.user!.uid, state.user!.fullName);
                          print("User logged in: ${state.user!.uid}");
                        } catch (e) {
                          print("Error during user login for ZegoCloud: $e");
                        }
                        return const HomeScreen();
                      }
                      return const LoginScreen();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
