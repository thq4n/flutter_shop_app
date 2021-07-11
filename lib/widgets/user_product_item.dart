import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: Text(product.title),
        trailing: FittedBox(
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: product);
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
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
                              Navigator.of(context).pop();
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
                              Provider.of<Products>(context, listen: false)
                                  .removeProduct(product);
                              Navigator.of(context).pop();
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
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
