import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void toggleIsFavorite() async {
    bool oldIsFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shopapp-38d5c-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldIsFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldIsFavorite;
      notifyListeners();
    }
  }
}
