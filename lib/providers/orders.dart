import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get items {
    return [..._orders];
  }

  void addOrder(double totalAmount, List<CartItem> cartItems) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: totalAmount,
            products: cartItems,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
