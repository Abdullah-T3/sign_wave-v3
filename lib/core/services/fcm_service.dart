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
    NotificationService().showNotification(
      title: message.notification!.title.toString(),
      body: '${message.notification!.body}',
    );
  }

  static void onForgroundMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService().showNotification(
          title: message.notification!.title.toString(),
          body: '${message.notification!.body}',
        );
      }
    });
  }
}
// register login logout
//fcm token (device abdullah =  )

// logout auth token (fcm token = "")

// ahmed fcm token
// id = 22

//auth token
//access token

// In the getAccessToken function
Future<String> getAccessToken() async {
  // Load from a local file that is not tracked by git
  final jsonString = await rootBundle.loadString(
    'secret/sign-language-translator-11862-7b0289a35b29.json',
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
  if (token.isEmpty) {
    return;
  }
  token = token.trim();

  final String accessToken = await getAccessToken();
  final String projectId = EnvHelper.getString('fbProjectId');
  final String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
  try {
    await dio.post(
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
              'aps': {'sound': 'custom_sound.caf', 'content-available': 1},
            },
          },
        },
      },
    );
  } catch (e) {
    rethrow;
  }
}
