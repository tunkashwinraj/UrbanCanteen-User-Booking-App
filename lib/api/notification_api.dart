// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
//
// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'high_importance_notification',
//     description: 'this channel is used for important notification',
//     importance: Importance.defaultImportance,
//   );
//
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//
//   Future<void> initLocalNotification() async {
//     // ... (rest of your code)
//   }
//
//   Future<void> initNotidications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('token: $fCMToken');
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     FirebaseMessaging.onMessage.listen((message) {
//       // ... (rest of your code)
//     });
//   }
//
// // ... (rest of your code)
// }
