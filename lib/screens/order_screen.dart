import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order_provider.dart' as ord;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = "\orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<ord.Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (dataSnapshot.error != null) {
              return Center(
                child: Text("Something go wrong!"),
              );
            } else {
              return Consumer<ord.Orders>(builder: (ctx, orderData, chile) {
                return orderData.orders.length > 0
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return OrderItem(orderData.orders[index]);
                        },
                        itemCount: orderData.orders.length,
                      )
                    : Center(
                        child: Text("You don't have any order!"),
                      );
              });
            }
          }),
    );
  }
}
