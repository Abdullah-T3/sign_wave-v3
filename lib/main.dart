import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sign_wave_v3/core/services/fcm_service.dart';
import 'package:sign_wave_v3/core/services/notifcation_service.dart';
import 'core/observer/app_life_cycle_observer.dart';
import 'features/home/data/repo/chat_repository.dart';
import 'core/services/di.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/home/presentation/home/home_screen.dart';
import 'features/auth/screens/auth/login_screen.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> _initializeApp() async {
  await Firebase.initializeApp();
  await setupServiceLocator();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // First initialize Firebase
  await _initializeApp().timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception('App initialization timed out'),
  );
  await dotenv.load(fileName: ".env");

  FirebaseMessaging.onBackgroundMessage(
    FcmService.firebaseMessagingBackgroundHandler,
  );

  FcmService.onForgroundMessage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _lifeCycleObserver;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeLifecycleObserver();
  }

  void _initializeLifecycleObserver() {
    // Initialize with empty user ID initially
    _lifeCycleObserver = AppLifeCycleObserver(
      userId: '',
      chatRepository: getIt<ChatRepository>(),
    );

    // Add observer immediately
    WidgetsBinding.instance.addObserver(_lifeCycleObserver);

    // Listen for auth state changes
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        key: navigatorKey,
        routes: {'/target': (context) => const HomeScreen()},
        title: 'Sign Wave Translator',
        navigatorKey: getIt<AppRouter>().navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          builder: (context, state) {
            if (state.status == AuthStatus.initial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.status == AuthStatus.authenticated) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
