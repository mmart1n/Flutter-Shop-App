import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import 'providers/auth.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider('', '', []),
          update: ((ctx, auth, previousProducts) => ProductsProvider(
              auth.token ?? '',
              auth.userId ?? '',
              previousProducts == null ? [] : previousProducts.items)),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: ((ctx, auth, orderData) => Orders(auth.token ?? '',
              auth.userId ?? '', orderData == null ? [] : orderData.orders)),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((ctx, auth, _) {
          ifAuth(targetScreen) {
            if (auth.isAuth) {
              return targetScreen;
            }
            // Navigator.of(ctx).pushReplacementNamed('/');
            return const AuthScreen();
          }

          return MaterialApp(
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultShanpshot) {
                      if (authResultShanpshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    },
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => ifAuth(const CartScreen()),
              OrdersScreen.routeName: (ctx) => ifAuth(const OrdersScreen()),
              UserProductsScreen.routeName: (ctx) =>
                  ifAuth(const UserProductsScreen()),
              EditProductScreen.routeName: (ctx) =>
                  ifAuth(const EditProductScreen()),
              AuthScreen.routeName: (ctx) => ifAuth(const AuthScreen()),
            },
          );
        }),
      ),
    );
  }
}
