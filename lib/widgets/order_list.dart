import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  OrderItem(this.orders);
  @override
  State<OrderItem> createState() => _OrderItemState();
}
                                                                                                                                                 
class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expanded ? min(widget.orders.products.length * 20.0 + 110, 200): 80,
      duration: Duration(milliseconds: 300),
      curve:Curves.easeIn,
      margin: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text("\$ ${widget.orders.total}"),
              subtitle:
                  Text(DateFormat.yMMMd().add_Hm().format(widget.orders.date)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(10),
                height: _expanded ? min(widget.orders.products.length * 20 + 50, 90):0,
                child: ListView(children:
                widget.orders.products.map((item)=>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${item.quantity}x \$${item.price}',
                          style: const TextStyle(fontSize: 19, color: Colors.grey),
                        ),
                      ],
                    )).toList()        
             ),
            )
          ],
        ),
      ),
    );
  }
}
