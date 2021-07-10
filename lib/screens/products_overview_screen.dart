import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, widget) => Badge(
                child: IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(CartScreen.routeName),
                  icon: Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                  ),
                ),
                value: cart.countCart().toString()),
          ),
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
          ),
        ],
      ),
      body: ProductsGrid(showFavoritedProducts),
    );
  }
}
