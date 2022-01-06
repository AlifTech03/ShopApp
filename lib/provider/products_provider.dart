import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'product.dart';

enum ChooseRemoving { Yes, No }

class Products with ChangeNotifier {
  List<Product> _items = [];
// data:image/jpeg;base64,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

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://flutter-update-a342d-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageurl": product.imageUrl,
            'creatorId': userId
          }));
      final newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filerString =
        filterByUser ? 'orderBy="creatorId"&equalTo=$userId' : '';
    var url = Uri.parse(
        'https://flutter-update-a342d-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filerString');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? allProducts = json.decode(response.body);
      url = Uri.parse(
          "https://flutter-update-a342d-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken");
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> latestProduct = [];
      allProducts?.forEach((prodId, prodData) {
        latestProduct.add(Product(
            id: prodId,
            title: prodData["title"],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageurl'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[prodId] ?? false));
      });
      _items = latestProduct;
      notifyListeners();
    } catch (error) {
      print('this is a fuckin $error');
      throw ('this is a fuckin $error');
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-a342d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageurl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Product loadedProduct(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  List<Product> get filterFavourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> removeProduct(String id) async {
    // final prodIndex = _items.indexWhere((element) => element.id == id);
    // final oldValue = _items[prodIndex];
    final url = Uri.parse(
        "https://flutter-update-a342d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    await http.delete(url);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
