import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome ♥"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
