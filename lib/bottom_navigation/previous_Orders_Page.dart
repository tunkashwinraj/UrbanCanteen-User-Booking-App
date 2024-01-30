import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/bottom_navigation/Previous_order_detail_page.dart';
import 'package:testingproback/food_items/food_item.dart';

class PreviousOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').
        where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).
        // where("status", isEqualTo: "Pending").
        snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No previous orders.'));
          }

          List<OrderModel> orders = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;

            // Check if the required fields exist, provide default values if not
            return OrderModel(
              transactionId: data['transactionId'] ?? '',
              items: List<Map<String, dynamic>>.from(data['cart'] ?? []),
              totalAmount: data['totalAmount'] ?? 0.0,
              address: data['address'] ?? '',
              paymentMethod: data['paymentMethod'] ?? '',
              status: data['status'] ?? '',
              timestamp: data['timestamp'] ?? Timestamp.now(),
            );
          }).toList();






          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${orders[index].transactionId}'),
                  subtitle: Text('Total Amount: ₹${orders[index].totalAmount.toStringAsFixed(2)}'),
                  onTap: () {
                    _navigateToOrderDetailsPage(context, orders[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToOrderDetailsPage(BuildContext context, OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }
}



class OrderModel {
  final String transactionId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String address;
  final String paymentMethod;
  final String status;
  final Timestamp timestamp;

  OrderModel({
    required this.transactionId,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });
}

