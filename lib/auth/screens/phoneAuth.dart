import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingproback/screens/homePage.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';

class PhoneAuthPage extends StatelessWidget {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController smsCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: userCredential.user),
            ),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      },
      codeSent: (String vId, int? resendToken) {
        verificationId = vId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval code has timed out
        // Perform appropriate action or prompt user to enter code manually
      },
    );
  }

  Future<void> _verifySmsCode(BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCodeController.text);
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: userCredential.user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _verifyPhoneNumber(context),
              child: Text('Verify Phone Number'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: smsCodeController,
              decoration: InputDecoration(labelText: 'Enter SMS Code'),
            ),
            ElevatedButton(
              onPressed: () => _verifySmsCode(context),
              child: Text('Verify SMS Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User? user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigation(),
    );
  }
}
