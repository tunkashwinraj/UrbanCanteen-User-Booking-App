import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/phonepe/PhonePePayment.dart';
import '../phonepe/success_screen.dart';

class CheckoutPage extends StatefulWidget {
  final List<FoodItem> cart;
  final String transactionId;

  CheckoutPage({required this.cart, required this.transactionId});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String address = '';
  String paymentMethod = 'Credit Card';

  // Reference to the 'orders' collection in Firestore
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Order Summary'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.cart[index].name),
                    subtitle: Text(widget.cart[index].description),
                    trailing: Text(
                        '\₹${widget.cart[index].price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Store order details in Firestore
                await _storeOrderDetails();

                // Navigate to the success page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      transactionId: widget.transactionId,
                      cart: widget.cart,
                      totalAmount: calculateTotalPrice(widget.cart),
                    ),
                  ),
                );
              },
              child: Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _storeOrderDetails() async {
    try {
      print('Storing order details...');
      print('Transaction ID: ${widget.transactionId}');
      print('Cart: ${widget.cart.map((item) => item.toMap()).toList()}');
      print('Total Amount: ${calculateTotalPrice(widget.cart)}');
      print('Address: $address');
      print('Payment Method: $paymentMethod');

      // Use the transactionId as the orderId
      String orderId = widget.transactionId;

      // Create a document in the 'orders' collection with orderId as the document ID
      await ordersCollection.doc(orderId).set({
        'transactionId': widget.transactionId,
        'cart': widget.cart.map((item) => item.toMap()).toList(),
        'totalAmount': calculateTotalPrice(widget.cart),
        'address': address,
        'paymentMethod': paymentMethod,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Order details stored successfully!');
    } catch (e) {
      print('Error storing order details: $e');
    }
  }


  double calculateTotalPrice(List<FoodItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }
}
