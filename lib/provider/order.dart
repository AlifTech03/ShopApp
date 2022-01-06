import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "cart.dart";

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double total;
  final DateTime date;

  OrderItem(
      {required this.products,
      required this.id,
      required this.total,
      required this.date});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getData() async {
    final url = Uri.parse(
        'https://flutter-update-a342d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadingProduct = [];
    final Map<String, dynamic> fetchingData = json.decode(response.body);
    fetchingData.forEach((ordId, ordData) {
      loadingProduct.add(OrderItem(
          products: (ordData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          id: ordId,
          total: ordData["total"],
          date: DateTime.parse(ordData['date'])));
    });
    _orders = loadingProduct.reversed.toList();
    notifyListeners();
  }

  Future<void> addItem(List<CartItem> products, double amount) async {
    final url = Uri.parse(
        'https://flutter-update-a342d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    var _timesStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "products": products
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
          "total": amount,
          "date": _timesStamp.toIso8601String(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          date: _timesStamp,
          total: amount,
          products: products,
        ));
    notifyListeners();
  }
}
