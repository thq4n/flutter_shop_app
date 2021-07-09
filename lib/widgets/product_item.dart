import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/product.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
              color: product.isFavorite
                  ? Theme.of(context).accentColor
                  : Colors.white.withOpacity(0.5),
              icon: Icon(
                Icons.favorite,
              ),
              onPressed: () {
                product.toggelProductFavorite(product);
        
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            onPressed: () {},
            icon: Icon(
              Icons.add_shopping_cart,
            ),
          ),
        ),
      ),
    );
  }
}
