import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testingproback/controller/cart_provider.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/screens/checkout_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _showClearCartConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          Map<FoodItem, int> cart = cartProvider.cart;

          return cart.isEmpty
              ? Center(child: Text('Your cart is empty.'))
              : ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final foodItem = cart.keys.toList()[index];
              final quantity = cart[foodItem];
              return ListTile(
                title: Text(foodItem.name),
                subtitle: Text(foodItem.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Qty: $quantity'),
                    SizedBox(width: 10),
                    Text(
                      '₹${(foodItem.price * quantity!).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                            context, foodItem, cartProvider);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return BottomAppBar(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${cartProvider.calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ElevatedButton(
                    onPressed: cartProvider.cart.isEmpty
                        ? null
                        : () {
                      // Navigate to the checkout page only if cart is not empty
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            cart: cartProvider.cart.keys.toList(),
                            transactionId:
                            "transaction_${DateTime.now().millisecondsSinceEpoch}",
                          ),
                        ),
                      );
                    },
                    child: Text('Checkout'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, FoodItem foodItem, CartProvider cartProvider) {
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
                cartProvider.removeFromCart(foodItem);
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Cart'),
          content: Text('Are you sure you want to remove all items from your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear the cart
                Provider.of<CartProvider>(context, listen: false).clearCart();
                Navigator.of(context).pop();
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
