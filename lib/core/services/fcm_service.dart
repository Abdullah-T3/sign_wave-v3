// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FCMService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Channel ID or Android notifications
//   static const String _channelId = 'sign_wave_channel';
//   static const String _channelName = 'Sign Wave Notifications';
//   static const String _channelDescription =
//       'Notifications for Sign Wave Translator app';

//   Future<void> initialize({
//     required Function(RemoteMessage) onMessageOpenedApp,
//     required Function(RemoteMessage) onMessage,
//     required Function(String) onTokenRefresh,
//   }) async {
//     // Request permission for iOS
//     if (Platform.isIOS) {
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     // Initialize local notifications
//     await _initializeLocalNotifications();

//     // Get FCM token
//     String? token = await _firebaseMessaging.getToken();
//     if (token != null) {
//       debugPrint('FCM Token: $token');
//       onTokenRefresh(token);
//     }

//     // Listen for token refresh
//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       debugPrint('FCM Token refreshed: $newToken');
//       onTokenRefresh(newToken);
//     });

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle messages when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('Got a message whilst in the foreground!');
//       debugPrint('Message data: ${message.data}');

//       if (message.notification != null) {
//         debugPrint(
//           'Message also contained a notification: ${message.notification}',
//         );
//         _showLocalNotification(message);
//       }

//       onMessage(message);
//     });

//     // Handle when app is opened from a notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('A new onMessageOpenedApp event was published!');
//       onMessageOpenedApp(message);
//     });

//     // Check if app was opened from a notification
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('App opened from terminated state via notification');
//       onMessageOpenedApp(initialMessage);
//     }
//   }

//   // Initialize local notifications
//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//           requestSoundPermission: true,
//           requestBadgePermission: true,
//           requestAlertPermission: true,
//           // Remove the problematic parameter
//         );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         // Handle notification tap
//         if (response.payload != null) {
//           final Map<String, dynamic> data = json.decode(response.payload!);
//           debugPrint('Notification payload: $data');
//         }
//       },
//     );

//     // Create Android notification channel
//     final AndroidNotificationChannel channel = AndroidNotificationChannel(
//       _channelId,
//       _channelName,
//       description: _channelDescription,
//       importance: Importance.high,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   // Show local notification
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null && !kIsWeb) {
//       _flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _channelId,
//             _channelName,
//             channelDescription: _channelDescription,
//             icon: android.smallIcon ?? '@mipmap/ic_launcher',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: json.encode(message.data),
//       );
//     }
//   }

//   // Subscribe to a topic
//   Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging.subscribeToTopic(topic);
//     debugPrint('Subscribed to topic: $topic');
//   }

//   // Unsubscribe from a topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging.unsubscribeFromTopic(topic);
//     debugPrint('Unsubscribed from topic: $topic');
//   }

//   // Get FCM token
//   Future<String?> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   // Delete FCM token
//   Future<void> deleteToken() async {
//     await _firebaseMessaging.deleteToken();
//     debugPrint('FCM Token deleted');
//   }
// }

// // Background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Need to initialize Firebase here
//   await Firebase.initializeApp();

//   debugPrint('Handling a background message: ${message.messageId}');
//   // You can't show UI (notifications) in the background handler
// }
