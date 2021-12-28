import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/product_item.dart';
import '/providers/products_provider.dart';

class GridViewBuilder extends StatelessWidget {
  final bool favoriteView;
  const GridViewBuilder({required this.favoriteView, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        favoriteView ? productsData.favoriteItems : productsData.productsItems;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 22,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(),
      ),
    );
  }
}
