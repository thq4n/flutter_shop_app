import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static String routeName = "/home-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: ProductsGrid(),
    );
  }
}
