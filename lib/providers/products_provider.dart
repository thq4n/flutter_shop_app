import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // bool _showAll = true;
  List<Product> _items = [];

  List<Product> get items {
    return _items;
  }

  List<Product> get favoritedItems {
    return _items.where((item) => item.isFavorite == true).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, proData) {
        loadedProducts.add(Product(
          id: productId,
          title: proData["title"],
          description: proData["description"],
          price: proData["price"],
          imageUrl: proData["imageUrl"],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      final url = Uri.parse(
          "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl,
            "isFavorite": newProduct.isFavorite,
          },
        ),
      );

      _items.add(Product(
        description: newProduct.description,
        id: json.decode(response.body),
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        title: newProduct.title,
        isFavorite: newProduct.isFavorite,
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
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
