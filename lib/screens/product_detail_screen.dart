import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
              ),
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    child: Hero(
                      tag: product.id,
                      child: FadeInImage(
                        placeholder:
                            AssetImage("assets/images/placeholder-image.png"),
                        image: NetworkImage(
                          product.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
