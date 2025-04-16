import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sign_wave_v3/core/helper/dotenv/dot_env_helper.dart';
import 'package:sign_wave_v3/core/services/di.dart';
import 'package:sign_wave_v3/core/services/notifcation_service.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

Dio dio = getIt<Dio>();
EnvHelper dotenvHelper = EnvHelper();

class FcmService {
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print('Handling a background message: ${message.messageId}');
    NotificationService().showNotification(
      title: '${message.notification!.title.toString()}',
      body: '${message.notification!.body}',
    );
  }

  static void onForgroundMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message received: ${message.notification!.title}');
        print('Message body: ${message.notification!.body}');
        NotificationService().showNotification(
          title: '${message.notification!.title.toString()}',
          body: '${message.notification!.body}',
        );
      }
    });
  }
}

// In the getAccessToken function

Future<void> sendNotification({
  required String token,
  required String title,
  required String body,
  required Map<String, String> data,
}) async {
  final String accessToken = getIt<String>(instanceName: 'accessToken');
  final String appID = EnvHelper.getString('fbAppId');
  // Updated FCM URL format
  final String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/$appID/messages:send';
  final response = await dio.post(
    fcmUrl,
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ),
    data: {
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'data': data,
        'android': {
          'notification': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'channel_id': 'high_importance_channel',
          },
        },

        'apns': {
          'payload': {
            'aps': {"sound": "custom_sound.caf", 'content-available': 1},
          },
        },
      },
    },
  );
  print('FCM Response: ${response.data}');
}
