import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order_provider.dart' as ord;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = "\orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<ord.Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: orderData.orders.length > 0
          ? ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItem(orderData.orders[index]);
              },
              itemCount: orderData.orders.length,
            )
          : Center(
              child: Text("You don't have any order!"),
            ),
    );
  }
}
