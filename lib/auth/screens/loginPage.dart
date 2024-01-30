import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingproback/auth/screens/SignUpPage.dart';
import 'package:testingproback/auth/screens/forgot_password.dart';
import 'package:testingproback/auth/screens/phoneAuth.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/screens/homePage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user; // Get the User object, which might be nullable

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneAuthPage(),

          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 250,
                width: 250,
                child: Image(image: AssetImage("assets/logo.png"))),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordPage()));
                },
                child: Text("Forgot Password")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signIn(context),
              child: Text('Sign In'),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                  },
                  child: Text("Sign Up")),
            ),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
