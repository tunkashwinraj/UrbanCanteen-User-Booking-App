import 'package:flutter/material.dart';


class TermsConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Terms & Conditions'),
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Container(
                child: Text('Welcome to Tunk Innovations Private Limited (“Tunk,” “we,” “us,” or “our”). These Terms and Conditions (“Terms”) '
                    'govern your access to and use of our services, including our mobile application (“App”), website, and any related features, content, or services (collectively, the “Services”). By accessing or using our Services, you agree to be bound by these Terms. If you do not agree to these Terms, please do not access or use our Services. '
                    '1. Account Creation'
                    "To access certain features of our Services, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. "
                    "You are solely responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account."

                    "2. Use of Services"
                    "You may use our Services only for lawful purposes and in accordance with these Terms. You agree not to use our Services:"
                    "In any way that violates any applicable law or regulation."
                    "To engage in any fraudulent, abusive, or otherwise inappropriate conduct."
                    "To impersonate any person or entity or falsely state or otherwise misrepresent your affiliation with any person or entity."
                    "To transmit any viruses, worms, defects, Trojan horses, or any items of a destructive nature."
                    "3. User Content"
                    "Our Services may allow you to create, post, share, or store content (“User Content”). You retain ownership of any intellectual property rights that you hold in the User Content. By posting User Content, you grant us a non-exclusive, "
                    "transferable, sub-licensable, royalty-free, worldwide license to use, modify, publicly perform, publicly display, reproduce, and distribute such User Content on or through our Services."
                    "4. Privacy Policy"
                    "Your use of our Services is also governed by our Privacy Policy, which is incorporated into these Terms by reference. Please review our Privacy Policy to understand our practices regarding the collection, use, and disclosure of your personal information."
                    "5. Termination"
                    "We reserve the right to terminate or suspend your access to our Services immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms. Upon termination, your right to use the Services will cease immediately."
                    '6. Changes to Terms'
                    'We may revise and update these Terms from time to time in our sole discretion. All changes are effective immediately when we post them. Your continued use of our Services following the posting of revised Terms means that you accept and agree to the changes.'
                    '7. Contact Us'
                    'If you have any questions about these Terms or our Services, please contact us at tunkinnovations@gmail.com.'
                    '8. Governing Law'
                    'These Terms shall be governed by and construed in accordance with the laws of the State of Telangana, India, without regard to its conflict of law provisions.'
                    'By using our Services, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree to these Terms, you may not access or use our Services.'
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}