import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggelProductFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !oldStatus;

    notifyListeners();
    try {
      final url = Uri.parse(
          "https://my-flutter-app-shop-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");

      await http.patch(url,
          body: jsonEncode({
            "isFavorite": isFavorite,
          }));
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
