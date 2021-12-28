import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get productsItems {
    return _products;
  }

  List<Product> get favoriteItems {
    return _products.where((product) => product.isFavorite).toList();
  }

  Future<void> getProducts() async {
    const url =
        'https://shopapp-38d5c-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      responseData.forEach(
        (productId, productValues) {
          loadedProducts.add(
            Product(
              id: productId,
              title: productValues['title'],
              description: productValues['description'],
              price: productValues['price'],
              imageUrl: productValues['imageUrl'],
              isFavorite: productValues['isFavorite'],
            ),
          );
        },
      );
      _products = loadedProducts.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct({required Product product}) async {
    const url =
        'https://shopapp-38d5c-default-rtdb.firebaseio.com/products.json';

    try {
      await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': false
          }));
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateProduct({required Product product}) async {
    int oldProductIndex = _products.indexWhere((prod) => prod.id == product.id);
    final url =
        'https://shopapp-38d5c-default-rtdb.firebaseio.com/products/${product.id}.json';
    http.patch(Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': _products[oldProductIndex].isFavorite
        }));
    notifyListeners();
  }

  void deleteProduct(String productId) async {
    final oldIndex = _products.indexWhere(
      ((product) => product.id == productId),
    );
    final oldProduct = _products[oldIndex];
    final url =
        'https://shopapp-38d5c-default-rtdb.firebaseio.com/products/$productId.json';
    try {
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
      await http.delete(
        Uri.parse(url),
      );
    } catch (error) {
      _products.insert(oldIndex, oldProduct);
      notifyListeners();
    }
  }

  Product findById(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  bool isExisting(String id) {
    bool isExisting = false;
    final oldIndex = _products.indexWhere((oldproduct) => oldproduct.id == id);
    if (oldIndex >= 0) {
      isExisting = true;
    } else {
      isExisting = false;
    }
    return isExisting;
  }
}
