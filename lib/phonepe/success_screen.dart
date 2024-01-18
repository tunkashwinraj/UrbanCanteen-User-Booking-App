import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:testingproback/food_items/food_item.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> sendFCMNotification(String userToken) async {
  final String serverKey = 'AAAAKi-BiEg:APA91bEncuK4sR48KUuO7FE58apIIKk89vkOQ1jqPRxAdkhImu33yMkIvZGEbTXYPhJfb7vLraorDq6XrgwXJPqDWU-LjpBo7q8zph7SruNAYqxxl0oHpuHqE-1l-lhGoY9ackjHDpBs';

  final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> data = {
    'to': userToken,
    'notification': {
      'title': 'Order Ready for Pickup',
      'body': 'Your order is ready for pickup.',
    },
    'data': {
      // You can include additional data if needed
    },
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('FCM notification sent successfully.');
  } else {
    print('Failed to send FCM notification. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

class SuccessScreen extends StatefulWidget {
  final String transactionId;
  final List<FoodItem> cart;
  final double totalAmount;
  final Function(String) onOrderReady;

  SuccessScreen({
    required this.transactionId,
    required this.cart,
    required this.totalAmount, required this.onOrderReady,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _configureFirebaseMessaging();

  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotificationDialog(
          context,
          message.notification?.title,
          message.notification?.body,
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    Future generateDeviceRegistrationToken() async {
      var orderId = widget.transactionId;
      String? deviceToken = await _firebaseMessaging.getToken();

      FirebaseFirestore.instance
          .collection('pending_orders')
          .doc(orderId)
          .update({
        "userDeviceToken": deviceToken,
      });
    }
  }

  void _showNotificationDialog(BuildContext context, String? title, String? body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: Text(body ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
