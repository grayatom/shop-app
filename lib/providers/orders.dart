import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final String authToken;
  final String userId;

  Orders({this.authToken, this.userId});

  List<OrderItem> _orders = [];
  List<OrderItem> get items {
    return [..._orders];
  }

  Future<void> addOrder(double totalAmount, List<CartItem> cartItems) async {
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken';
    var productsList = [];
    cartItems.forEach((element) {
      productsList.add({
        'id': element.id,
        'title': element.title,
        'price': element.price,
        'quantity': element.quantity,
      });
    });
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'userId': userId,
            'amount': totalAmount,
            'products': productsList,
            'dateTime': DateTime.now().toIso8601String(),
          },
        ),
      );
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: totalAmount,
              products: cartItems,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (e) {
      print('Error occurred, ${e.toString()}');
    }
  }

  Future<void> loadOrders() async {
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken&orderBy="userId"&equalTo="$userId"';
    List<OrderItem> _loadedOrders = [];
    try {
      final response = await http.get(url);
      var _extractedData = json.decode(response.body);
      if (_extractedData == null) return;
      _extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List).map((product) {
              return CartItem(
                id: product['id'],
                price: product['price'],
                quantity: product['quantity'],
                title: product['title'],
              );
            }).toList()));
      });
      _orders = _loadedOrders;
    } catch (e) {
      print('Error: ${e.toString()} occurred.');
    }
  }
}
