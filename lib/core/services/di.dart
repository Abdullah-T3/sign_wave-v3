import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:sign_wave_v3/core/helper/dotenv/dot_env_helper.dart';
import 'package:sign_wave_v3/core/services/jitsi_call.dart';
import 'package:sign_wave_v3/core/services/notifcation_service.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_cubit.dart';
import 'package:sign_wave_v3/firebase_options.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/home/data/repo/chat_repository.dart';
import '../../features/home/data/repo/contact_repository.dart';
import '../../features/auth/logic/auth/auth_cubit.dart';
import '../../router/app_router.dart';
// Add these imports
import 'call_notification_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions();
  await NotificationService().initNotification();
  Dio dio = Dio();
  final messaging = FirebaseMessaging.instance;
  dynamic firebaseToken = await messaging.getToken();
  print('notification status ${firebaseToken.toString()}');
  final String accessToken = await getAccessToken();
  //-------------------------------------------------//
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  // Register FirebaseMessaging
  getIt.registerLazySingleton<String>(
    () => firebaseToken.toString(),
    instanceName: 'firebaseToken',
  );
  getIt.registerLazySingleton<String>(
    () => accessToken,
    instanceName: 'accessToken',
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => ContactRepository());
  getIt.registerLazySingleton(() => ChatRepository());
  getIt.registerLazySingleton(
    () => AuthCubit(authRepository: AuthRepository()),
  );
  getIt.registerFactory(
    () => ChatCubit(
      chatRepository: ChatRepository(),
      userData: getIt<FirebaseAuth>().currentUser!,
    ),
  );

  // Register JitsiMeet
  //getIt.registerLazySingleton(() => JitsiMeet());

  // Register CallNotificationService
  getIt.registerLazySingleton(() => CallNotificationService());

  // Initialize call notification service
  await getIt<CallNotificationService>().initialize();

  // Register JitsiMeetService with the injected JitsiMeet instance
  // getIt.registerLazySingleton(() => JitsiMeetService(getIt<JitsiMeet>()));
}

Future<String> getAccessToken() async {
  // Load from a local file that is not tracked by git
  final jsonString = await rootBundle.loadString(
    'secret/sign-language-translator-11862-1d331b021b72.json',
  );

  final accountCredentials = auth.ServiceAccountCredentials.fromJson(
    jsonString,
  );

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  return client.credentials.accessToken.data;
}
