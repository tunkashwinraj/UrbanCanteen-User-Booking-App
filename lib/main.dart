import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/auth/screens/googleLogin.dart';
import 'package:testingproback/auth/screens/loginPage.dart';
import 'package:testingproback/auth/screens/phoneAuth.dart';
import 'package:testingproback/firebase_options.dart';
import 'package:testingproback/screens/homePage.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';

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
      initialRoute: '/phone_auth',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => BottomNavigation(),
        '/google_signup': (context) => GoogleSignUpPage(),
        '/phone_auth': (context) => PhoneAuthPage(),
        // Add other routes as needed
      },
    );
  }
}
