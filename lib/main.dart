import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/api/notification_api.dart';
import 'package:testingproback/auth/screens/googleLogin.dart';
import 'package:testingproback/firebase_options.dart';
import 'package:testingproback/screens/homePage.dart';
import 'package:testingproback/auth/screens/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,

  );

  //await FirebaseApi().initNotifications();


  // Initialize Firebase Cloud Messaging
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received FCM message: ${message.data}');
    // Handle the FCM message here, e.g., show a notification
  });



  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),


      routes: {
        '/login': (context) => LoginPage(),
        '/google_signup': (context) => GoogleSignUpPage(),
        // Other routes...
      },
    );
  }
}