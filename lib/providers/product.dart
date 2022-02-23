import 'package:flutter/foundation.dart';
import '../models/http_exceptions.dart';
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

  Future<void> toggleFavouriteStatus(
      String prodId, String authToken, String userId) async {
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$prodId.json?auth=$authToken';
    isFavourite = !isFavourite;
    notifyListeners();
    final response = await http.put(
      url,
      body: json.encode(
        isFavourite,
      ),
    );
    if (response.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw HttpException('Some error occurred.');
    }
  }
}
