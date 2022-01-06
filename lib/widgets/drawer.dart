import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';
import '../provider/auth.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/");
            },
            leading: Icon(
              Icons.shopping_bag,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Your Shop",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
            leading: Icon(
              Icons.shopping_basket_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Your Order List",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Manage Product",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Log Out",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
    );
  }
}
