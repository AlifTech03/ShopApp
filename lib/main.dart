import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Import File
import 'screens/splash_screen.dart';
import 'provider/auth.dart';
import 'provider/order.dart';
import 'screens/cart_screen.dart';
import 'screens/user_product_screen.dart';
import 'provider/products_provider.dart';
import 'screens/products_overview_screen.dart';
import 'screens/products_detail_screen.dart';
import 'provider/cart.dart';
import 'screens/order_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(
                Provider.of<Auth>(context, listen: false).token!,
                Provider.of<Auth>(context, listen: false).userId!, []),
            update: (context, value, previous) => Products(value.token!,
                value.userId!, previous == null ? [] : previous.items)),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(
                Provider.of<Auth>(context, listen: false).token!,
                Provider.of<Auth>(context, listen: false).userId!, []),
            update: (context, value, previous) => Orders(value.token!,
                value.userId!, previous == null ? [] : previous.orders)),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.purple,
            fontFamily: "Raleway",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: TransactionBuilder(),
              TargetPlatform.iOS: TransactionBuilder(),
            }),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.deepOrange, primaryContainer: Colors.white),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.toAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditPrductScreen.routeName: (ctx) => EditPrductScreen()
          },
        ),
      ),
    );
  }
}
