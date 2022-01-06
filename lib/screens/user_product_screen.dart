import 'package:flutter/material.dart';
import '../widgets/user_product.dart';
import '../provider/products_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user-product";

  Future<void> _refreshHandler(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    print('dsfsdfsdf');
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: const Text("Manage Product"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditPrductScreen.routeName);
              },
              icon: const Icon(Icons.add_box_rounded))
        ],
      ),
      body: FutureBuilder(
        future: _refreshHandler(context),
        builder: (ctx, snapsot) =>
            snapsot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.purple,),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshHandler(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                  id: productData.items[index].id,
                                  title: productData.items[index].title,
                                  imageUrl: productData.items[index].imageUrl),
                              const Divider()
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
