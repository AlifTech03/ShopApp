import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    var quantity = 0;
    _items.forEach((key, value) {
      quantity+=value.quantity;
    });
    return quantity;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((Key, element) {
      total += element.price * element.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingElement) => CartItem(
              id: existingElement.id,
              title: existingElement.title,
              price: existingElement.price,
              quantity: existingElement.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
