import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid(
    this.showFavs, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    var products = showFavs ? productsData.favoriteItems : productsData.items;
    return products.isEmpty && !showFavs
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
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            // itemBuilder: (ctx, i) => ChangeNotifierProvider(
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              // ignore: prefer_const_constructors
              child: ProductItem(
                  // products[i].id,
                  // products[i].title,
                  // products[i].imageUrl,
                  // products[i].price,
                  ),
              value: products[i],
              // create: (ctx) => products[i],
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
