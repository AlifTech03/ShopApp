import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Orders;
import '../widgets/order_list.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = "/orderScreen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .getData()
        .then((_) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Your Order"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : ListView.builder(
                itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
                itemCount: orderData.orders.length,
              ));
  }
}
