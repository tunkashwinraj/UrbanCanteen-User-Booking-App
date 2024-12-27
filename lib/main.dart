import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testingproback/auth/screens/googleLogin.dart';
import 'package:testingproback/auth/screens/loginPage.dart';
import 'package:testingproback/auth/screens/phoneAuth.dart';
import 'package:testingproback/controller/cart_provider.dart';
import 'package:testingproback/firebase_options.dart';
import 'package:testingproback/screens/QRScannerPage.dart';
import 'package:testingproback/screens/homePage.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';
import 'package:testingproback/auth/screens/phoneAuth.dart' as CustomPhoneAuth;


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.requestPermission();

  // Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final userUid = prefs.getString('userUid');
  if (userUid != null) {
    // If user is logged in, directly navigate to the home screen
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CustomPhoneAuth.AuthProvider()..setUser(FirebaseAuth.instance.currentUser)),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          // Add other providers as needed
        ],
        child: MyApp(),
      ),
    );
  } else {
    // If user is not logged in, show the phone authentication page
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CustomPhoneAuth.AuthProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          // Add other providers as needed
        ],
        child: MyApp(),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/phone_auth',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => BottomNavigation(),
        '/google_signup': (context) => GoogleSignUpPage(),
        '/phone_auth': (context) => PhoneAuthPage(),
        '/qrs': (context) => QRScanner(),
        // Add other routes as needed
      },
    );
  }
}

///final
