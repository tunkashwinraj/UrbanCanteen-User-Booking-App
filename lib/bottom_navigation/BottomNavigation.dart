import 'package:flutter/material.dart';
import 'package:testingproback/bottom_navigation/previous_Orders_Page.dart';
import 'package:testingproback/bottom_navigation/profile_page.dart';
import 'package:testingproback/food_items/food_item.dart';
import 'package:testingproback/screens/cart_page.dart';
import 'package:testingproback/screens/homePage.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  List<FoodItem> cart = [];
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onCartUpdated: _updateCart),
      CartPage(cart: cart),
      PreviousOrdersPage(),
      ProfilePage(),
    ];
  }
  void _updateCart(List<FoodItem> updatedCart) {
    print("Cart updated: $updatedCart");
    setState(() {
      cart = updatedCart;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: _navigateToCart,
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (cart.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          cart.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Previous Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cart: cart),
      ),
    );
  }
}
