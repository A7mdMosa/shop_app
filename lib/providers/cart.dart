import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;
  String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return _cartItems;
  }

  int get itemsCount {
    return _cartItems.length;
  }

  int get quantityCount {
    int quantity = 0;
    _cartItems.forEach((key, value) {
      quantity += value.quantity;
    });
    return quantity;
  }

  double get totalAmout {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addQuantity(String id) {
    _cartItems.update(
      id,
      (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity == 100
              ? existingItem.quantity
              : existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl),
    );
    notifyListeners();
  }

  void removeQuantity(String id) {
    _cartItems.update(
      id,
      (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity == 1
              ? existingItem.quantity
              : existingItem.quantity - 1,
          imageUrl: existingItem.imageUrl),
    );
    notifyListeners();
  }

  void addItem(String productId, String productTitle, double productPrice,
      String productImageUrl) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
            imageUrl: existingItem.imageUrl),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: productTitle,
            price: productPrice,
            quantity: 1,
            imageUrl: productImageUrl),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId]!.quantity > 1) {
      _cartItems.update(
        productId,
        (oldItem) => CartItem(
            id: oldItem.id,
            title: oldItem.title,
            price: oldItem.price,
            quantity: oldItem.quantity - 1,
            imageUrl: oldItem.imageUrl),
      );
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }
}
