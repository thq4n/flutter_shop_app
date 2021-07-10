import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order_provider.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.order.amount}\$"),
            subtitle: Text(
              DateFormat("dd-MM-yyyy hh:mm").format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              height: min(widget.order.products.length * 20.0 + 100, 90),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  var product = widget.order.products[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${product.quantity} x ${product.price.toStringAsFixed(2)}\$ = ${product.quantity * double.parse(product.price.toStringAsFixed(2))}\$",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            )
        ],
      ),
    );
  }
}
