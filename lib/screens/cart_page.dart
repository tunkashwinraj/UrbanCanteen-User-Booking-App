import 'package:flutter/material.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/screens/checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<FoodItem> cart;

  CartPage({required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          final foodItem = widget.cart[index];
          return ListTile(
            title: Text(foodItem.name),
            subtitle: Text(foodItem.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('₹${foodItem.price.toStringAsFixed(2)}' , style: TextStyle(fontSize: 16.0)),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.cart.removeAt(index);
                      calculateTotalPrice(widget.cart);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ₹${calculateTotalPrice(widget.cart).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the checkout page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        cart: widget.cart,
                        transactionId: "transaction_${DateTime.now().millisecondsSinceEpoch}",
                      ),
                    ),
                  );
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotalPrice(List<FoodItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }
}
