import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String name;
  final String description;
  final double price;
  final bool isVisible;
  int quantity;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.isVisible,
    this.quantity = 0, // Initialize quantity with default value 0
  });

  // Constructor to create a FoodItem from a DocumentSnapshot
  // Constructor to create a FoodItem from a QueryDocumentSnapshot
  FoodItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'],
        description = snapshot['description'],
        price = snapshot['price'],
        isVisible = snapshot['isVisible'],
        quantity = 0; // Initialize quantity to 0



  // Add a toMap method to convert FoodItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'isVisible': isVisible,
    };
  }
}

///original
