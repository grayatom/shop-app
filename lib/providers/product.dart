import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String prodId) async {
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$prodId.json';
    isFavourite = !isFavourite;
    notifyListeners();
    await http.patch(
      url,
      body: json.encode(
        {'isFavourite': isFavourite},
      ),
    );
  }
}
