import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: productsData.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'An error occurred!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text('Please check your internet connection'),
                    Text('or try again later!'),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        id: productsData.items[i].id,
                        title: productsData.items[i].title,
                        imageUrl: productsData.items[i].imageUrl,
                      ),
                      const Divider(),
                    ],
                  ),
                  itemCount: productsData.items.length,
                ),
              ),
            ),
    );
  }
}
