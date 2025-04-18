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
Future<String> getAccessToken() async {
  // Load from a local file that is not tracked by git
  final jsonString = await rootBundle.loadString(
    'secret/sign-language-translator-11862-ff16840068c0.json',
  );

  final accountCredentials = auth.ServiceAccountCredentials.fromJson(
    jsonString,
  );

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  return client.credentials.accessToken.data;
}

Future<void> sendNotification({
  required String token,
  required String title,
  required String body,
  required Map<String, String> data,
}) async {
  try {
    final String accessToken = await getAccessToken();
    final String appID = EnvHelper.getString('fbAppId');
    final String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/${appID}/messages:send';

    final response = await dio.post(
      fcmUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          // Add accept header
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status! < 500; // Accept all status codes less than 500
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
              'aps': {'sound': 'custom_sound.caf', 'content-available': 1},
            },
          },
        },
      },
    );

    if (response.statusCode == 403) {
      print('Authentication error: ${response.data}');
      throw Exception(
        'FCM Authentication failed. Please check your credentials.',
      );
    }

    if (response.statusCode != 200) {
      print('FCM Error: ${response.data}');
      throw Exception('Failed to send notification: ${response.statusCode}');
    }

    print('Notification sent successfully');
  } catch (e) {
    print('Error sending notification: $e');
    rethrow;
  }
}
