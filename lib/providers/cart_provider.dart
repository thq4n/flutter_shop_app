import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    this.quantity = 1,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(Product item) {
    if (_items.containsKey(item.id)) {
      _items.update(
        item.id,
        (existedItem) => CartItem(
            id: item.id,
            price: item.price,
            title: item.title,
            quantity: existedItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        item.id,
        () => CartItem(
            id: UniqueKey().toString(), price: item.price, title: item.title),
      );
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  int countCart() {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
