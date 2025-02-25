import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testingproback/auth/screens/loginPage.dart';
import 'package:testingproback/screens/cart_page.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:badges/badges.dart' as badges;
import 'package:testingproback/utils/utilies.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodItem> foodItems = [
    FoodItem(name: 'Manchuria', description: 'Delicious Manchuria', price: 50),
    FoodItem(name: 'Fried Rice', description: 'Tasty fired rice', price: 40),
    FoodItem(name: 'Meals', description: 'All mix meals', price: 60),
    FoodItem(name: 'noodles', description: 'Tasty noodles', price: 40),
    // Add more food items here
  ];

  List<FoodItem> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [
           IconButton(onPressed: (){
             FirebaseAuth.instance.currentUser;
             FirebaseAuth.instance.signOut().then((value){
               Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
             });
           },
             icon: Icon(Icons.logout_outlined),)
         ],
        title: Text(' CMREC Canteen'),
      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(foodItems[index].name),
              subtitle: Text(foodItems[index].description),
              trailing: Text('\₹${foodItems[index].price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0), ),
              onTap: () {
                // Handle adding the item to the cart
                setState(() {
                  cart.add(foodItems[index]);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: badges.Badge(
        badgeContent: Text(cart.length.toString()), // Show the cart item count
        position: badges.BadgePosition.topEnd(top: -12, end: -12), // Adjust the badge position
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(cart: cart),
              ),
            );
          },
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
