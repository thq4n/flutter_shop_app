import 'package:flutter/material.dart';
import 'package:flutter_shop_app/data/data.dart';
import 'package:flutter_shop_app/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = STORED_PRODUCTS;

  List<Product> get items {
    return _items;
  }

  void addProduct() {
    // _items.add(item);
    notifyListeners();
  }

  void removeProduct(Product item) {
    _items.remove(item);
    notifyListeners();
  }

  
}
