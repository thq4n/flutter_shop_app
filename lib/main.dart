import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrange,
        ),
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My app"),
        ),
        body:
            null // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
