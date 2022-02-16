import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exceptions.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

const url =
    'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map;
    List<Product> _loadProducts = [];
    extractedData.forEach((prodId, prodData) {
      _loadProducts.add(
        Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: prodData['isFavourite'],
        ),
      );
    });
    _items = _loadProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product newProd) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': newProd.title,
            'description': newProd.description,
            'price': newProd.price,
            'imageUrl': newProd.imageUrl,
            'isFavourite': false,
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
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
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
        'https://shop-app-1902f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
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
