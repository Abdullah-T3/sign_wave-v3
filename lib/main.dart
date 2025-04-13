import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/observer/app_life_cycle_observer.dart';
import 'features/home/data/repo/chat_repository.dart';
import 'core/services/di.dart';
import 'features/auth/logic/auth/auth_cubit.dart';
import 'features/auth/logic/auth/auth_state.dart';
import 'features/home/presentation/home/home_screen.dart';
import 'features/auth/screens/auth/login_screen.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  runApp(const MyApp());
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

    // Initialize _lifeCycleObserver with a default value if needed
    _lifeCycleObserver = AppLifeCycleObserver(
      userId: '', // Provide a default empty userId
      chatRepository: getIt<ChatRepository>(),
    );

    // Listen for changes in AuthCubit state
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        // Update _lifeCycleObserver only if authenticated
        setState(() {
          _lifeCycleObserver = AppLifeCycleObserver(
            userId: state.user!.uid,
            chatRepository: getIt<ChatRepository>(),
          );
        });
      }

      // Add the observer to WidgetsBinding once it's initialized
      WidgetsBinding.instance.addObserver(_lifeCycleObserver);
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
