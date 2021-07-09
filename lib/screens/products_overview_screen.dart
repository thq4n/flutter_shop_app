import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FILTER_OPTIONS {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static String routeName = "/home-page";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavoritedProducts;

  @override
  void initState() {
    showFavoritedProducts = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text("Show all"),
                  value: FILTER_OPTIONS.All,
                ),
                PopupMenuItem(
                  child: Text("Show favorited products"),
                  value: FILTER_OPTIONS.Favorites,
                ),
              ];
            },
            icon: Icon(Icons.more_vert),
            onSelected: (selectedValue) {
              if (selectedValue == FILTER_OPTIONS.Favorites) {
                setState(() {
                  showFavoritedProducts = true;
                });
              } else {
                setState(() {
                  showFavoritedProducts = false;
                });
              }
            },
          )
        ],
      ),
      body: ProductsGrid(showFavoritedProducts),
    );
  }
}
