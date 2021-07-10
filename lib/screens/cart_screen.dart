import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart' show Cart;
import 'package:flutter_shop_app/providers/order_provider.dart';
import 'package:flutter_shop_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "${cart.totalAmount.toStringAsFixed(2)}\$",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: Text("ORDER NOW"),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                var item = cart.items.values.toList()[index];
                return CartItem(
                    productId: cart.items.keys.toList()[index],
                    id: item.id,
                    price: item.price,
                    title: item.title,
                    quantity: item.quantity);
              },
              itemCount: cart.countCart(),
            ),
          ),
        ],
      ),
    );
  }
}
