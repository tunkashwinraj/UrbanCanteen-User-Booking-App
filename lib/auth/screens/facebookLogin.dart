// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:testingproback/auth/screens/SignUpPage.dart';
//
// class FacebookSignUpPage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<UserCredential?> _signInWithFacebook(BuildContext context) async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login();
//       if (result.status == LoginStatus.success) {
//         final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
//         final UserCredential userCredential = await _auth.signInWithCredential(credential);
//         if (userCredential.user != null) {
//           Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
//         }
//         return userCredential;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Facebook')));
//         return null;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Facebook: $e')));
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Facebook Sign-Up'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await _signInWithFacebook(context);
//           },
//           child: Text('Sign Up with Facebook'),
//         ),
//       ),
//     );
//   }
// }
