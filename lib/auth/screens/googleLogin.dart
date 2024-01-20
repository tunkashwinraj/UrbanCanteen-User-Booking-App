import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testingproback/auth/screens/SignUpPage.dart';
import 'package:testingproback/screens/homePage.dart';

class GoogleSignUpPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(onCartUpdated: (cart) {})));
      }
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Google: $e')));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-Up'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _signInWithGoogle(context);
          },
          child: Text('Sign Up with Google'),
        ),
      ),
    );
  }
}
