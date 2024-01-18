class FoodItem {
  final String name;
  final String description;
  final double price;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
  });

  // Add a toMap method to convert FoodItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
