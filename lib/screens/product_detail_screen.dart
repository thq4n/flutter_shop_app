import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
