import 'package:flutter/material.dart';
import 'package:testingproback/food_items/food_item.dart';

class CartProvider extends ChangeNotifier {
  Map<FoodItem, int> _cart = {};

  Map<FoodItem, int> get cart => _cart;
  String address = '';
  String paymentMethod = 'Credit Card';

  void addToCart(FoodItem foodItem) {
    if (_cart.containsKey(foodItem)) {
      _cart[foodItem] = _cart[foodItem]! + 1; // Increase quantity if item already exists
    } else {
      _cart[foodItem] = 1; // Add new item with quantity 1
    }
    notifyListeners();
  }

  // Add this method to update the item quantity in the cart
  void updateCartItem(FoodItem foodItem) {
    if (_cart.containsKey(foodItem)) {
      _cart[foodItem] = foodItem.quantity; // Update quantity
      notifyListeners();
    }
  }
  void updateCartItemQuantity(FoodItem foodItem, int quantity) {
    if (_cart.containsKey(foodItem)) {
      _cart[foodItem] = quantity; // Update quantity
      notifyListeners();
    }
  }

  void removeFromCart(FoodItem foodItem) {
    if (_cart.containsKey(foodItem)) {
      if (_cart[foodItem] == 1) {
        _cart.remove(foodItem); // If quantity is 1, remove the item
      } else {
        _cart[foodItem] = (_cart[foodItem] ?? 0) - 1; // Decrement quantity if greater than 1
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double calculateTotalPrice() {
    double total = 0;
    _cart.forEach((foodItem, quantity) {
      total += foodItem.price * quantity;
    });
    return total;
  }
}
