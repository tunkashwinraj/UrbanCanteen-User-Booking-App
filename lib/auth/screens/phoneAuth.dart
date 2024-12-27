import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';


class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> setUser(User? user) async {
    _user = user;
    // Persist user authentication state
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      prefs.setString('userUid', user.uid);
    } else {
      prefs.remove('userUid');
    }
    notifyListeners();
  }

  Future<void> checkUserLoggedIn() async {
    // Check if user is already logged in
    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString('userUid');
    if (userUid != null) {
      // If user is logged in, set the user object
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setUser(currentUser);
      }
    }
  }
}


class PhoneAuthPage extends StatefulWidget {
  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  String _verificationStatusMessage = '';

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    Provider.of<AuthProvider>(context, listen: false).checkUserLoggedIn();
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    final fullPhoneNumber = '+91${phoneNumberController.text}';
    if (phoneNumberController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid 10-digit phone number')));
      return;
    }

    setState(() {
      _isLoading = true;
      _verificationStatusMessage = 'Please wait for the bot verification';
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: Duration(seconds: 120), // Add timeout parameter here
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          User updatedUser = await _auth.currentUser!;
          await updatedUser.reload();
          await updatedUser.getIdToken(true);

          // Create a user model with phone number as UID
          UserModel userModel = UserModel(uid: fullPhoneNumber, phoneNumber: fullPhoneNumber);

          // Store the user's data in Firestore with phone number as UID
          await FirebaseFirestore.instance
              .collection('userPhone')
              .doc(userModel.uid)
              .set({
            'phoneNumber': userModel.phoneNumber,
            // Add other user data as needed
          }, SetOptions(merge: true));

          Provider.of<AuthProvider>(context, listen: false).setUser(updatedUser);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
          _verificationStatusMessage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      },
      codeSent: (String vId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _verificationStatusMessage = 'OTP sent to $fullPhoneNumber';
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(verificationId: vId, phoneNumber: fullPhoneNumber),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80),
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/app_logo1.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter 10-digit number',
                  prefixText: '+91',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _verifyPhoneNumber(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: Text(
                  'Verify Phone Number',
                  style: TextStyle(fontSize: 18, color: Colors.white),

                ),
              ),
              SizedBox(height: 20),
              if (_isLoading) CircularProgressIndicator(),
              if (_verificationStatusMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _verificationStatusMessage,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


}

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OtpPage({required this.verificationId, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController smsCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  String _verificationStatusMessage = '';

  Future<void> _verifySmsCode(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _verificationStatusMessage = 'Please wait till we verify';
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCodeController.text,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        User updatedUser = await _auth.currentUser!;
        await updatedUser.reload();
        await updatedUser.getIdToken(true);

        Provider.of<AuthProvider>(context, listen: false).setUser(updatedUser);

        setState(() {
          _isLoading = false;
          _verificationStatusMessage = 'OTP Verified Successfully';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _verificationStatusMessage = 'OTP Verification Failed. Please try again.';
      });
      print("Error verifying OTP: $e");
    }
  }


  Future<void> _resendOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _verificationStatusMessage = 'Please wait till we resend OTP';
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Handle verification completed if necessary
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
          _verificationStatusMessage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      },
      codeSent: (String vId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _verificationStatusMessage = 'OTP resent to ${widget.phoneNumber}';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP resent to ${widget.phoneNumber}')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _changeNumber(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PhoneAuthPage()));
    // Navigator.pop(context); // Pop the OTP page
    // Navigator.pop(context); // Pop the PhoneAuthPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/app_logo1.jpg',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                _verificationStatusMessage,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text('OTP sent to ${widget.phoneNumber}'),
              SizedBox(height: 20),

              TextFormField(
                controller: smsCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter SMS Code',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _verifySmsCode(context),
                child: Text('Verify SMS Code'),
              ),
              if (_isLoading) CircularProgressIndicator(), // Show circular progress indicator if loading
              SizedBox(height: 10),
              TextButton(
                onPressed: _isLoading ? null : () => _resendOtp(context),
                child: Text('Resend OTP'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _isLoading ? null : () => _changeNumber(context),
                child: Text('Change Mobile Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserModel {
  final String uid;
  final String phoneNumber;

  UserModel({required this.uid, required this.phoneNumber});
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your actual HomeScreen implementation
    return BottomNavigation();
  }
}

///original
///original-16-03-24