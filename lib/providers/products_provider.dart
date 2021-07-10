import 'package:flutter/material.dart';
import 'package:flutter_shop_app/data/data.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';

class Products with ChangeNotifier {
  // bool _showAll = true;
  List<Product> _items = STORED_PRODUCTS;

  List<Product> get items {
    return _items;
  }

  List<Product> get favoritedItems {
    return _items.where((item) => item.isFavorite == true).toList();
  }

  // void showAllProducts() {
  //   _showAll = true;

  //   notifyListeners();
  // }

  // void showFavoritedProducts() {
  //   _showAll = false;

  //   notifyListeners();
  // }

  void addProduct() {
    // _items.add(item);
    notifyListeners();
  }

  void removeProduct(Product item) {
    _items.remove(item);
    notifyListeners();
  }

  Product findById(String id){
    return _items.where((item) => item.id == id).toList().first;
  }
}
