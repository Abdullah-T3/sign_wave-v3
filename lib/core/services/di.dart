import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_wave_v3/core/services/fcm_service.dart';
import 'package:sign_wave_v3/core/services/notifcation_service.dart';
import 'package:sign_wave_v3/features/auth/screens/cubit/auth_cubit.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_cubit.dart';
import 'package:sign_wave_v3/features/home/presentation/profile/cubit/profile_cubit.dart';
import 'package:sign_wave_v3/firebase_options.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/home/data/repo/chat_repository.dart';
import '../../features/home/data/repo/contact_repository.dart';
import '../../router/app_router.dart';
import '../localization/cubit/localization_cubit.dart';
import '../theme/cubit/theme_cubit.dart' show ThemeCubit;
// Add these imports

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseMessaging.setForegroundNotificationPresentationOptions();
  await NotificationService().initNotification();
  Dio dio = Dio();
  final prefs = await SharedPreferences.getInstance();

  FirebaseMessaging.onBackgroundMessage(
    FcmService.firebaseMessagingBackgroundHandler,
  );
  FcmService.onForgroundMessage();

  final fcmToken = await firebaseMessaging.getToken();

  getIt.registerSingleton<ThemeCubit>(ThemeCubit(prefs: prefs));
  getIt.registerSingleton<LocalizationCubit>(LocalizationCubit(prefs: prefs));
  //-------------------------------------------------//
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  getIt.registerLazySingleton<String>(
    instanceName: 'fcmToken',
    () => fcmToken!,
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => ContactRepository());
  getIt.registerLazySingleton(() => ChatRepository());
  getIt.registerLazySingleton(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => ChatCubit(
      chatRepository: getIt<ChatRepository>(),
      userData: getIt<FirebaseAuth>().currentUser!,
    ),
  );

  getIt.registerFactory(
    () => ProfileCubit(authRepository: getIt<AuthRepository>()),
  );

  // Register JitsiMeet
  //getIt.registerLazySingleton(() => JitsiMeet());

  // Register JitsiMeetService with the injected JitsiMeet instance
  // getIt.registerLazySingleton(() => JitsiMeetService(getIt<JitsiMeet>()));
}
