import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

mixin ConnectedProductsModel on Model {
  List<Product> products = [];
  User authenticatedUser;
  String selProductId;

  bool isLoading = false;

  Future<bool> addProduct(
      String title, String description, double price, String image) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-project-products.firebaseio.com/products.json?auth=${authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      products.add(newProduct);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    // ).catchError((error) {
    //   isLoading = false;
    //   notifyListeners();
    //   return false;
    // }); //vsetky erorry napr kebz ti nesiel internet a podobne
  }
}
