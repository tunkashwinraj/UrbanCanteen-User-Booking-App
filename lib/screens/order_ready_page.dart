import 'package:flutter/material.dart';
import 'package:testingproback/food_items/food_item.dart';

class OrderReadyPage extends StatelessWidget {
  final String transactionId;
  final List<FoodItem> cart;
  final double totalAmount;
  final String userPhoneNumber;

  OrderReadyPage({
    required this.transactionId,
    required this.cart,
    required this.totalAmount,
    required this.userPhoneNumber, required List orderedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Ready'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Icon(
                Icons.shopping_bag,
                size: 100,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Order is Ready!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Go and pick up your order",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "User Phone Number:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                userPhoneNumber,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Order ID:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                transactionId,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Ordered Items:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cart[index].name),
                    // Add more details if needed
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Total Amount: ₹$totalAmount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

///added