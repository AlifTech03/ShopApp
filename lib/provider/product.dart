import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  void _isFav(bool oldvalue) {
    isFavourite = oldvalue;
    notifyListeners();
  }

  Future<void> toogleFavourite(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-update-a342d-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400){
        _isFav(oldStatus);
      }
    } catch (error) {
      print(error);
      _isFav(oldStatus);
    }
  }
}
