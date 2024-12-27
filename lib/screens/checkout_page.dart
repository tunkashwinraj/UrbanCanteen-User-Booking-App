import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseFirestore.instance.collection('new_orders');

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
            Text(
              'Total Amount: \₹${calculateTotalPrice(widget.cart).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Store order details in Firestore
                await _storeOrderDetails();
                _navigateToPhonePeGateway();
                await _storeOrderHistory();
                await _storeCantOrders();


                // Navigate to the success page
                Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PhonePePayment(
      transactionId: widget.transactionId,
      cart: widget.cart,
      totalAmount: calculateTotalPrice(widget.cart),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
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

  Future<void> _storeOrderHistory() async {
    try {
      print('Storing order details...');
      print('Transaction ID: ${widget.transactionId}');
      print('Cart: ${widget.cart.map((item) => item.toMap()).toList()}');
      print('Total Amount: ${calculateTotalPrice(widget.cart)}');
      print('Address: $address');
      print('Payment Method: $paymentMethod');

      // Get the user token
      String? userToken = await _getAndStoreUserToken();

      // Get current user's UID and phone
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String phone = FirebaseAuth.instance.currentUser!.phoneNumber ?? '';

      // Create a document in the 'history' collection with orderId as the document ID
      await FirebaseFirestore.instance.collection('history').doc(widget.transactionId).set({
        'transactionId': widget.transactionId,
        'cart': widget.cart.map((item) => item.toMap()).toList(),
        'totalAmount': calculateTotalPrice(widget.cart),
        'address': address,
        'paymentMethod': paymentMethod,
        'status': 'New Order',
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid,
        'userToken': userToken,
        'phone': phone,
      });

      print('Order details stored successfully in history collection!');
    } catch (e) {
      print('Error storing order details: $e');
    }
  }



  Future<void> _storeCantOrders() async {
    try {
      print('Storing order details...');
      print('Transaction ID: ${widget.transactionId}');
      print('Cart: ${widget.cart.map((item) => item.toMap()).toList()}');
      print('Total Amount: ${calculateTotalPrice(widget.cart)}');
      print('Address: $address');
      print('Payment Method: $paymentMethod');

      // Get the user token
      String? userToken = await _getAndStoreUserToken();

      // Get current user's UID and phone
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String phone = FirebaseAuth.instance.currentUser!.phoneNumber ?? '';

      // Create a document in the 'history' collection with orderId as the document ID
      await FirebaseFirestore.instance.collection('cantorders').doc(widget.transactionId).set({
        'transactionId': widget.transactionId,
        'cart': widget.cart.map((item) => item.toMap()).toList(),
        'totalAmount': calculateTotalPrice(widget.cart),
        'address': address,
        'paymentMethod': paymentMethod,
        'status': 'New Order',
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid,
        'userToken': userToken,
        'phone': phone,
      });

      print('Order details stored successfully in history collection!');
    } catch (e) {
      print('Error storing order details: $e');
    }
  }




  Future<void> _storeOrderDetails() async {
    try {
      print('Storing order details...');
      print('Transaction ID: ${widget.transactionId}');
      print('Cart: ${widget.cart.map((item) => item.toMap()).toList()}');
      print('Total Amount: ${calculateTotalPrice(widget.cart)}');
      print('Address: $address');
      print('Payment Method: $paymentMethod');

      // Get the user token
      String? userToken = await _getAndStoreUserToken();

      // Use the transactionId as the orderId
      String orderId = widget.transactionId;

      // Create a document in the 'orders' collection with orderId as the document ID
      await ordersCollection.doc(orderId).set({
        'transactionId': widget.transactionId,
        'cart': widget.cart.map((item) => item.toMap()).toList(),
        'totalAmount': calculateTotalPrice(widget.cart),
        'address': address,
        'paymentMethod': paymentMethod,
        'status': 'New Order',
        'timestamp': FieldValue.serverTimestamp(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
        'userToken': userToken,
        "phone": FirebaseAuth.instance.currentUser!.phoneNumber
      });

      print('Order details stored successfully!');
    } catch (e) {
      print('Error storing order details: $e');
    }


  }

  Future<String?> _getAndStoreUserToken() async {
    try {
      // Get the FCM token
      String? userToken = await FirebaseMessaging.instance.getToken();

      if (userToken != null && userToken.isNotEmpty) {
        // Store the user token in Firestore
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.transactionId)
            .set({
          'userToken': userToken,
          "phone": FirebaseAuth.instance.currentUser!.phoneNumber
        }, SetOptions(merge: true));

        print('User token stored in Firestore: $userToken');
        return userToken;
      } else {
        print('Failed to get FCM token.');
        return null;
      }
    } catch (e) {
      print('Error getting and storing FCM token: $e');
      return null;
    }
  }


  double calculateTotalPrice(List<FoodItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  void _navigateToPhonePeGateway() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhonePePayment(
          transactionId: widget.transactionId,
          cart: widget.cart,
          totalAmount: calculateTotalPrice(widget.cart),
        ),
      ),
    );

    // Handle the result if needed
    if (result != null) {
      // Do something with the result
      print('Result from PhonePeGatewayPage: $result');
    }
  }
}

///original 16-03-24
