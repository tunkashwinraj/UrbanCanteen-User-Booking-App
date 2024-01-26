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
  void initState() {
    super.initState();
    print("CartPage initialized. Initial Cart: ${widget.cart}");
  }

  @override
  void didUpdateWidget(CartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("CartPage updated. Updated Cart: ${widget.cart}");
  }




  @override
  Widget build(BuildContext context) {
    print("CartPage rebuilt. Cart: ${widget.cart}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          final foodItem = widget.cart[index];
          return ListTile(
            title: Text(foodItem.name),
            subtitle: Text(foodItem.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('₹${foodItem.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0)),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(index);
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

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure you want to remove this item from your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.cart.removeAt(index);
                  calculateTotalPrice(widget.cart);
                });
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
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
