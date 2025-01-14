import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testingproback/food_items/food_item.dart';

class SuccessScreen extends StatefulWidget {
  final String transactionId;
  final List<FoodItem> cart;
  final double totalAmount;

  SuccessScreen({
    required this.transactionId,
    required this.cart,
    required this.totalAmount,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _getAndStoreUserToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // Add your logic to handle the background message
  }




  Future<void> _getAndStoreUserToken() async {
    try {
      // Get the FCM token
      String? userToken = await _firebaseMessaging.getToken();

      if (userToken != null && userToken.isNotEmpty) {
        // Store the user token in Firestore
        await _storeUserToken(userToken);
      } else {
        print('Failed to get FCM token.');
      }
    } catch (e) {
      print('Error getting and storing FCM token: $e');
    }
  }

  Future<void> _storeUserToken(String userToken) async {
    try {

      // Store the user token in Firestore
      await FirebaseFirestore.instance.collection('orders').doc(widget.transactionId).set({
        'userToken': userToken,
      }, SetOptions(merge: true));

      print('User token stored in Firestore: $userToken');
    } catch (e) {
      print('Error storing user token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: QrImageView(
                      data: widget.transactionId,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your unique ID:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.transactionId,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    "Billed Items:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: widget.cart.map((item) => ListTile(
                      title: Text(item.name),
                      trailing: Text("₹${item.price.toStringAsFixed(2)}"),
                    )).toList(),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    "Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
