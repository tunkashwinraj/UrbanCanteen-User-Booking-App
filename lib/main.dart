import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/auth/screens/googleLogin.dart';
import 'package:testingproback/firebase_options.dart';
import 'package:testingproback/screens/homePage.dart';
import 'package:testingproback/auth/screens/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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


