import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testingproback/controller/cart_provider.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CMREC Canteen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FoodItemList(),
          ),
        ],
      ),
    );
  }
}

class FoodItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('food_items').where('isVisible', isEqualTo: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final foodItems = snapshot.data!.docs.map((doc) => FoodItem.fromSnapshot(doc as QueryDocumentSnapshot<Map<String, dynamic>>)).toList();

        return ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            return FoodItemCard(foodItem: foodItems[index]);
          },
        );
      },
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemCard({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(
            foodItem.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            foodItem.description,
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
            '\₹${foodItem.price.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onTap: () {
            Provider.of<CartProvider>(context, listen: false).addToCart(foodItem);
            _showSnackbar(context, 'Item added to cart');
          },
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class Order {
  final String transactionId;
  final double totalAmount;

  Order({
    required this.transactionId,
    required this.totalAmount,
  });

  factory Order.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Order(
      transactionId: data['transactionId'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction ID: ${order.transactionId}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total Amount: \₹${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
