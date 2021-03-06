import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/custom_route.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/providers/order_provider.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders("", "", []),
          update: (ctx, auth, priviousOrders) =>
              Orders(auth.token, auth.userId, priviousOrders!.orders),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products("", "", []),
          update: (ctx, auth, previousProductsProvider) =>
              previousProductsProvider == null
                  ? Products("", "", [])
                  : previousProductsProvider
                ..updateUser(
                  auth.token,
                  auth.userId,
                ),
          // update: (ctx, auth, priviousProducts) =>
          //     Products(auth.token, auth.userId, priviousProducts!.items),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, authData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop',
          theme: ThemeData(
            fontFamily: "Lato",
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrange,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
          home: authData.isAuth()
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        );
      }),
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
