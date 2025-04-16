import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart' show GetIt;

import '../../features/home/presentation/chat/cubits/chat_cubit.dart';

class CallNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle incoming messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Handle messages when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // Handle messages when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;

    // Check if this is a call notification
    if (data['type'] == 'call_invitation') {
      final callId = data['callId'];
      final callerName = data['callerName'];
      final callerId = data['callerId'];

      // Get the ChatCubit and handle the incoming call
      final chatCubit = GetIt.instance<ChatCubit>();
    }
  }
}
