import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testingproback/auth/screens/googleLogin.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/pro.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${user?.displayName ?? ''}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${user?.email ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement sign out functionality
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await _auth.signOut();

      // Navigate to the GoogleSignUpPage after signing out
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GoogleSignUpPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign out: $e')));
    }
  }

}
