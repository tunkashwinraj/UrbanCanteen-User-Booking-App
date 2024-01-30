import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:testingproback/bottom_navigation/BottomNavigation.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }
}

class PhoneAuthPage extends StatelessWidget {
  final TextEditingController phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    // Adding +91 as the default country code
    final fullPhoneNumber = '+91${phoneNumberController.text}';

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Provider.of<AuthProvider>(context, listen: false).setUser(userCredential.user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      },
      codeSent: (String vId, int? resendToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(verificationId: vId, phoneNumber: fullPhoneNumber),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval code has timed out
        // Perform appropriate action or prompt user to enter code manually
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication - Enter Phone Number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.network(
                'https://img.freepik.com/free-vector/global-data-security-personal-data-security-cyber-data-security-online-concept-illustration-internet-security-information-privacy-protection_1150-37375.jpg?size=626&ext=jpg&ga=GA1.1.714735951.1704461322&semt=ais',
                height: 200, // Adjust the height as needed
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '1234567891',
                  prefixText: '+91',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _verifyPhoneNumber(context),
                child: Text('Verify Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpPage extends StatelessWidget {
  final String verificationId;
  final TextEditingController smsCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String phoneNumber;

  OtpPage({required this.verificationId, required this.phoneNumber});

  Future<void> _verifySmsCode(BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCodeController.text);
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      Provider.of<AuthProvider>(context, listen: false).setUser(userCredential.user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  Future<void> _resendOtp(BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Handle verification completed if necessary
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      },
      codeSent: (String vId, int? resendToken) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP resent to $phoneNumber')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval code has timed out
        // Perform appropriate action or prompt user to enter code manually
      },
    );
  }

  Future<void> _changeNumber(BuildContext context) async {
    Navigator.pop(context); // Pop the OTP page
    // You can add logic to navigate back to the phone number entry page or any other desired page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication - Enter OTP'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.network(
                'https://img.freepik.com/free-vector/global-data-security-personal-data-security-cyber-data-security-online-concept-illustration-internet-security-information-privacy-protection_1150-37375.jpg?size=626&ext=jpg&ga=GA1.1.714735951.1704461322&semt=ais',
                height: 200, // Adjust the height as needed
              ),
              SizedBox(height: 20),
              Text(
                'OTP sent to $phoneNumber',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                onPressed: () => _verifySmsCode(context),
                child: Text('Verify SMS Code'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => _resendOtp(context),
                child: Text('Resend OTP'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => _changeNumber(context),
                child: Text('Change Mobile Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigation(),
    );
  }
}
