import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';

enum FilterOptions {
  All,
  Favourites,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
      Provider.of<Products>(context, listen: false)
          .fetchProduct()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("My Shop"),
          actions: [
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch!,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart_sharp),
              ),
            ),
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favourites) {
                      _showFavourites = true;
                    } else {
                      _showFavourites = false;
                    }
                  });
                },
                icon: const Icon(Icons.more_vert),
                itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        child: Text("Only Favourites"),
                        value: FilterOptions.Favourites,
                      ),
                      const PopupMenuItem(
                        child: Text("All Product"),
                        value: FilterOptions.All,
                      ),
                    ]),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : ProductGrid(_showFavourites));
  }
}
