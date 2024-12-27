import 'package:flutter/material.dart';



class RefundPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Refund Policy'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Container(
              child: Text('Thank you for using our Services at Tunk Innovations Private Limited (“Tunk”). Please read this policy carefully. '
                  'This is the Refund Policy of Tunk.'
                  "1. Non-Refundable Purchases"
                  "All purchases made through our Services are non-refundable. This includes but is not limited to:"
                  "Fees for subscriptions or memberships."
                  "Digital products or services."
                  "In-app purchases."
                  "2. No Guarantee"
                  "We do not guarantee refunds for dissatisfaction with the Services or for any other reason."
                  "3. Contact Us"
                  "If you have any questions about our Refund Policy, please contact us at tunkinnovations@gmail.com."
                  "4. Changes to Refund Policy"
                  "We reserve the right to modify or update our Refund Policy at any time without prior notice. Any changes to the Refund Policy will be effective immediately upon posting on our website or through our Services. Your continued use of our Services after the posting of changes constitutes your acceptance of such changes."
                  "By using our Services, you acknowledge that you have read, understood, and agree to be bound by our Refund Policy. If you do not agree to our Refund Policy, please refrain from using our Services."
              ),
            ),
          ),
        ),
      ),
    );
  }
}
