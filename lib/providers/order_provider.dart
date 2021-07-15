import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.amount,
    required this.dateTime,
    required this.id,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String? _authToken;
  final String? _userId;

  List<OrderItem> get orders {
    return _orders;
  }

  Orders(this._authToken, this._userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/userOrders/$_userId/orders.json?auth=$_authToken");
    final response = await http.get(url);

    List<OrderItem> loadedOrders = [];

    if (json.decode(response.body) == null) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderID, orderData) {
      loadedOrders.add(OrderItem(
        amount: orderData["amount"],
        dateTime: DateTime.parse(orderData["dateTime"]),
        id: orderID,
        products: (orderData["products"] as List<dynamic>)
            .map(
              (item) => CartItem(
                  id: item["id"],
                  price: item["price"],
                  title: item["title"],
                  quantity: item["quantity"]),
            )
            .toList(),
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    if (cartProducts.length > 0) {
      final url = Uri.parse(
          "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/userOrders/$_userId/orders.json?auth=$_authToken");

      final timestamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            "products": cartProducts
                .map(
                  (item) => {
                    "id": item.id,
                    "price": item.price,
                    "quantity": item.quantity,
                    "title": item.title,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          amount: total,
          dateTime: timestamp,
          id: json.decode(response.body)["name"],
          products: cartProducts,
        ),
      );
      notifyListeners();
    }
  }
}
