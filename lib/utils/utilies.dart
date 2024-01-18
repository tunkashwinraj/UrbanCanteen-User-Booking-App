// utils.dart

import 'package:testingproback/food_items/food_item.dart';

class Utils {
  static double calculateTotalPrice(List<FoodItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }
}












// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class Utils{
//   void toastMessage(String message){
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//       fontSize: 18.0,
//     );
//   }
// }