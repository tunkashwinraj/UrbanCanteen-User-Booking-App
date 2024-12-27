import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingproback/auth/screens/phoneAuth.dart';
import 'package:testingproback/screens/Terms_conditions.dart';
import 'package:testingproback/screens/feedbackForm.dart';
import 'package:testingproback/screens/refund_policy.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/pro.jpg'), // Replace with your random image
            ),
            SizedBox(height: 16),
            Text(
              'Phone Number: ${FirebaseAuth.instance.currentUser!.phoneNumber ?? 'N/A'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement sign out functionality
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
            SizedBox(height: 32),
            ListTile(
              title: Text("Provide Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackForm(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Terms & Conditions"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsConditions(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Refund Policy"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RefundPolicy(),
                  ),
                );
              },
            ),
            Divider(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Developed & Designed by Tunk Innovations Private Limited',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            Text("Version: 1.0.5 "),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut();

      // Navigate to the PhoneAuthPage after signing out
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PhoneAuthPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign out: $e')));
    }
  }
}

///original
