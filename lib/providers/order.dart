import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return _orders;
  }

  int get ordersCount {
    return _orders.length;
  }

  Future<void> getOrders() async {
    const url = 'https://shopapp-38d5c-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(
      Uri.parse(url),
    );
    final extendedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];

    extendedResponse.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity'],
                  imageUrl: e['imageUrl']),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateTimeNow = DateTime.now();
    const url = 'https://shopapp-38d5c-default-rtdb.firebaseio.com/orders.json';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'amount': total,
          'dateTime': dateTimeNow.toIso8601String(),
          'products': cartProducts
              .map((cardItem) => {
                    'id': cardItem.id,
                    'title': cardItem.title,
                    'price': cardItem.price,
                    'quantity': cardItem.quantity,
                    'imageUrl': cardItem.imageUrl
                  })
              .toList()
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
          id: jsonDecode(response.body)['name'],
          amount: total,
          dateTime: dateTimeNow,
          products: cartProducts),
    );
    notifyListeners();
  }
}
