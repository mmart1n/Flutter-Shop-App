import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
      'flutter-shop-app-d806a-default-rtdb.europe-west1.firebasedatabase.app',
      '/orders/$userId.json',
      {
        'auth': authToken,
      },
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      (extractedData as Map<String, dynamic>).forEach((orderId, orderData) {
        final orderItem = OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (prod) => CartItem(
                  id: prod['id'],
                  title: prod['title'],
                  quantity: prod['quantity'],
                  price: prod['price'],
                ),
              )
              .toList(),
        );
        loadedOrders.add(orderItem);
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.https(
      'flutter-shop-app-d806a-default-rtdb.europe-west1.firebasedatabase.app',
      '/orders/$userId.json',
      {
        'auth': authToken,
      },
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartProd) => {
                    'id': cartProd.id,
                    'title': cartProd.title,
                    'quantity': cartProd.quantity,
                    'price': cartProd.price,
                  })
              .toList(),
        }),
      );
      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
