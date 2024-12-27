import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingproback/QR/QRCodeGenerator.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/screens/QRScannerPage.dart';
import 'package:testingproback/screens/order_ready_page.dart';

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
  late String status;
  late String userPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('new_orders')
          .doc(widget.transactionId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text("Order not found"),
            ),
          );
        }
        final orderData = snapshot.data!;
        if (!orderData.exists ||
            !(orderData.data() as Map<String, dynamic>).containsKey('status')) {
          print('Error: Document does not exist or status field is missing');
          return Scaffold(
            body: Center(
              child: Text("Error: Order not found"),
            ),
          );
        }
        status = orderData['status'];
        final message = _getMessageForStatus(status);
        return FutureBuilder(
          future: _getUserPhoneNumber(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return Scaffold(
                body: Center(
                  child: Text("User phone number not found"),
                ),
              );
            }
            userPhoneNumber = userSnapshot.data.toString();
            return _buildSuccessScreen(message);
          },
        );
      },
    );
  }

  Future<String> _getUserPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('userPhone')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return userDoc['phoneNumber'];
      }
    }
    return '';
  }

  Widget _buildSuccessScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Text(
              'Phone Number: ${FirebaseAuth.instance.currentUser!.phoneNumber ?? 'N/A'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              "Billed Items:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Column(
              children: widget.cart
                  .map(
                    (item) => ListTile(
                  title: Text(item.name),
                  trailing:
                  Text("₹${item.price.toStringAsFixed(2)}"),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              "Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      "Order Status",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildStatusSteps(status),
                  SizedBox(height: 10),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to QR Scanner Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScanner(orderId: widget.transactionId)),
                );
              },
              icon: Icon(Icons.qr_code),
              label: Text('Scan QR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSteps(String currentStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _orderStatus
          .map(
            (status) => Column(
          children: [
            _buildStatusIcon(status, currentStatus),
            SizedBox(height: 5),
            Text(
              status,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: currentStatus == status ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }

  Widget _buildStatusIcon(String status, String currentStatus) {
    IconData iconData;
    Color color;

    if (status == currentStatus) {
      iconData = Icons.check_circle;
      color = Colors.blue;
    } else {
      iconData = Icons.circle;
      color = Colors.grey;
    }

    return Icon(
      iconData,
      color: color,
    );
  }

  String _getMessageForStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Your order is Scanned! Status pending.';
      case 'Preparing':
        return 'Your order is Preparing.';
      case 'Prepared':
        return 'Your order is prepared.';
      case 'Picked Up':
        return 'Your order has been Picked up.';
      default:
        return 'Scan your order in Canteen';
    }
  }

  static const List<String> _orderStatus = [
    'Pending',
    'Preparing',
    'Prepared',
    'Picked',
  ];
}
