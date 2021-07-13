import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
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

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    showFavoritedProducts = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }

    super.didChangeDependencies();
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
      drawer: AppDrawer(),
      body: Stack(children: [
        ProductsGrid(showFavoritedProducts),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}
