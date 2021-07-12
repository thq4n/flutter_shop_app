import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/data/data.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // bool _showAll = true;
  List<Product> _items = storedProducts;

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

  Future<void> addProduct(Product newProduct) {
    final url = Uri.parse(
        "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    return http
        .post(
      url,
      body: json.encode(
        {
          "id": newProduct.id,
          "title": newProduct.title,
          "description": newProduct.description,
          "price": newProduct.price,
          "imageUrl": newProduct.imageUrl,
          "isFavorite": newProduct.isFavorite,
        },
      ),
    )
        .catchError(
      (error) {
        print(error);
        throw error;
      },
    ).then(
      (value) {
        _items.add(newProduct);
        notifyListeners();
      },
    );
  }

  void removeProduct(Product item) {
    _items.remove(item);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.where((item) => item.id == id).toList().first;
  }

  void reload() {
    notifyListeners();
  }

  void modifyProduct(Product newProduct) {
    var index = _items.indexWhere((item) => item.id == newProduct.id);
    _items[index] = newProduct;
    notifyListeners();
  }
}
