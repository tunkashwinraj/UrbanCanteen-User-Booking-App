import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingproback/QR/QRCodeGenerator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../screens/QRScannerPage.dart';

class PreviousOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Orders'),
      ),
      body: OrderList(),
    );
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cantorders')
          //.orderBy('timestamp', descending: true)
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No orders.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            OrderModel order = OrderModel(
              transactionId: orderData['transactionId'] ?? '',
              items: List<Map<String, dynamic>>.from(orderData['cart'] ?? []),
              totalAmount: orderData['totalAmount'] ?? 0.0,
              address: orderData['address'] ?? '',
              paymentMethod: orderData['paymentMethod'] ?? '',
              status: orderData['status'] ?? '',
              timestamp: orderData['timestamp'] ?? Timestamp.now(),
            );
            return buildOrderTile(context, order);
          },
        );
      },
    );
  }

  Widget buildOrderTile(BuildContext context, OrderModel order) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Order ID: ${order.transactionId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusUI(order.status), // Updated status UI
            Text('Date: ${order.timestamp.toDate().toString()}'),
            Text('Items:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) {
                return Text('${item['name']} - ₹${item['price'].toStringAsFixed(2)}');
              }).toList(),
            ),
          ],
        ),
        onTap: () async {
          // Navigate to OrderDetailsPage and await the result
          var updatedOrder = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(order: order),
            ),
          );

          // Handle the updated order status if any
          if (updatedOrder != null) {
            // Assuming updatedOrder is of type OrderModel
            // You can update the UI accordingly or handle the update as needed
            print('Updated order status: ${updatedOrder.status}');
          }
        },
      ),
    );
  }

  Widget _buildStatusUI(String status) {
    return Row(
      children: [
        for (var i = 0; i < _orderStatus.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _orderStatus.indexOf(status)
                    ? Colors.green
                    : Colors.grey,
              ),
              child: i == _orderStatus.indexOf(status)
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            ),
          ),
        Text(
          status,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<String> _orderStatus = [
    'Pending',
    'Preparing',
    'Prepared',
    'Picked Up',
  ];
}

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  OrderDetailsPage({required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Stream<DocumentSnapshot> _orderStream;

  @override
  void initState() {
    super.initState();
    _orderStream = FirebaseFirestore.instance.collection('cantorders').doc(widget.order.transactionId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Order not found.'));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;
          OrderModel updatedOrder = OrderModel(
            transactionId: orderData['transactionId'] ?? '',
            items: List<Map<String, dynamic>>.from(orderData['cart'] ?? []),
            totalAmount: orderData['totalAmount'] ?? 0.0,
            address: orderData['address'] ?? '',
            paymentMethod: orderData['paymentMethod'] ?? '',
            status: orderData['status'] ?? '',
            timestamp: orderData['timestamp'] ?? Timestamp.now(),
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Order ID:', updatedOrder.transactionId),
                  _buildDetailRow('Total Amount:', '₹${updatedOrder.totalAmount.toStringAsFixed(2)}'),
                  _buildDetailRow('Address:', updatedOrder.address),
                  _buildDetailRow('Payment Method:', updatedOrder.paymentMethod),
                  _buildDetailRow('Status:', _buildStatusUI(updatedOrder.status)), // Updated status UI
                  _buildDetailRow('Timestamp:', updatedOrder.timestamp.toDate().toString()),
                  Divider(),
                  Text(
                    'Phone Number: ${FirebaseAuth.instance.currentUser!.phoneNumber ?? 'N/A'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Items:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: updatedOrder.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(updatedOrder.items[index]['name']),
                        subtitle: Text('₹${updatedOrder.items[index]['price'].toStringAsFixed(2)}'),
                      );
                    },
                  ),
                  // Display the QR code based on the transaction ID
                  if (updatedOrder.status == 'New Order')
                    Center(
                      child: Column(
                        children: [
                          _buildDetailRow('QR Code:', SizedBox(height: 200, width: 200, child: QRCodeGenerator.generateQRCode(updatedOrder.transactionId))),
                          SizedBox(height: 16),
                          Text('Scan the QR code in canteen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                          SizedBox(
                            height: 20,

                          ),
                          ElevatedButton(
                            onPressed: () {
                              _scanQRCode();
                            },
                            child: Text('Scan QR Code'),
                          ),
                        ],

                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScanner(orderId: widget.order.transactionId),
      ),
    );

    if (result != null && result == true) {
      // QR code was successfully scanned and order status updated
      setState(() {
        // Refresh the UI with the updated order status
      });
    }
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          // Check if the value is a String or Widget
          if (value is String)
            Text(
              value,
              style: TextStyle(fontSize: 16.0),
            )
          else if (value is Widget)
            value,
        ],
      ),
    );
  }

  Widget _buildStatusUI(String status) {
    return Row(
      children: [
        for (var i = 0; i < _orderStatus.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _orderStatus.indexOf(status)
                    ? Colors.green
                    : Colors.grey,
              ),
              child: i == _orderStatus.indexOf(status)
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            ),
          ),
        Text(
          status,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<String> _orderStatus = [
    'Pending',
    'Preparing',
    'Prepared',
    'Picked Up',
  ];
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

///original