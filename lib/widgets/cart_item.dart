import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              height: 50,
              width: 50,
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placeholder-image.png"),
                image: NetworkImage(
                  Provider.of<Products>(context, listen: false)
                      .findById(productId)
                      .imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: ${(price * quantity).toStringAsFixed(2)}\$"),
            trailing: Text("${price.toStringAsFixed(2)}\$ x $quantity"),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Delete Confirmation",
                style: TextStyle(
                  color: Colors.yellow.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("Do you want to remove this item?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancle",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
