import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourites;
  ProductGrid(this.showFavourites);
  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<Products>(context);
    final productData =
        showFavourites ? productList.filterFavourites : productList.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: productData[index],
            child: ProductItem(),
          )),
      itemCount: productData.length,
    );
  }
}
