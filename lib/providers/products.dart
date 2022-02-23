import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exceptions.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;

  Products({this.authToken, this.userId});

  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchAndSetProducts([filterByUid = false]) async {
    var filterSegment =
        filterByUid ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterSegment';

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map;
    url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
    final userFavProdResponse = await http.get(url);
    final userFavProdData = json.decode(userFavProdResponse.body);
    List<Product> _loadProducts = [];
    extractedData.forEach((prodId, prodData) {
      _loadProducts.add(
        Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: userFavProdData == null
              ? false
              : userFavProdData[prodId] ?? false,
        ),
      );
    });
    _items = _loadProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product newProd) async {
    try {
      final url =
          'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': newProd.title,
            'description': newProd.description,
            'price': newProd.price,
            'imageUrl': newProd.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: newProd.title,
          description: newProd.description,
          price: newProd.price,
          imageUrl: newProd.imageUrl,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> updateProduct(Product newProd) async {
    final id = newProd.id;
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    await http.patch(
      url,
      body: json.encode(
        {
          'title': newProd.title,
          'description': newProd.description,
          'price': newProd.price,
          'imageUrl': newProd.imageUrl,
          'isFavourite': newProd.isFavourite,
        },
      ),
    );
    var prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = newProd;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingProdIdx = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIdx];
    _items.removeAt(existingProdIdx);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIdx, existingProd);
      notifyListeners();
      throw HttpException('Some error occurred!');
    } else {
      existingProd = null;
    }
  }
}
