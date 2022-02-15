import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCnt {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeOneItem(String productId) {
    if (_items[productId].quantity > 1) {
      _items.update(productId, (value) {
        return CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity - 1);
      });
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addToCart({String productId, String title, double price}) {
    if (_items.containsKey(productId)) {
      // update the current quantity
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity + 1),
      );
    } else {
      // add to the map _items
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
