import 'package:flutter/material.dart';

class OrderReadyNotifier extends ChangeNotifier {
  List<String> _readyOrders = [];

  List<String> get readyOrders => _readyOrders;

  void addReadyOrder(String orderId) {
    _readyOrders.add(orderId);
    notifyListeners();
  }
}
