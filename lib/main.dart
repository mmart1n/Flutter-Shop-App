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
// import './helpers/custom_route.dart';
import 'providers/theme_provider.dart';
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
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: ((ctx, auth, orderData) => Orders(auth.token ?? '',
              auth.userId ?? '', orderData == null ? [] : orderData.orders)),
        ),
      ],
      child: Consumer2<Auth, ThemeProvider>(
        builder: ((ctx, auth, themeProvider, _) {
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
              brightness: Brightness.light,
              fontFamily: 'Lato',
              // use to apply different page transitions for all screens
              // pageTransitionsTheme: PageTransitionsTheme(
              //   builders: {
              //     TargetPlatform.android: CustomPageTransitionBuilder(),
              //     TargetPlatform.iOS: CustomPageTransitionBuilder(),
              //   },
              // ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode == 'System'
                ? ThemeMode.system
                : themeProvider.themeMode == 'Dark'
                    ? ThemeMode.dark
                    : ThemeMode.light,
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: Future.wait([
                      auth.tryAutoLogin(),
                      themeProvider.getSelectedTheme()
                    ]),
                    builder:
                        (ctx, AsyncSnapshot<List<Object>> authResultShanpshot) {
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
