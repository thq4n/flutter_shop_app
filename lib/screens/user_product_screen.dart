import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/mmanage-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);
    var products = productsData.items;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              var product = products[index];
              return UserProductItem(product);
            },
            itemCount: products.length,
          ),
        ),
      ),
    );
  }
}
