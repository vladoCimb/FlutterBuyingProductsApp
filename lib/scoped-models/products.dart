import 'package:scoped_model/scoped_model.dart';
import './connected_products.dart';
import '../models/product.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allproducts {
    return List.from(
        products); //vytvarame novy list a teda neodkazujeme sa na rovnake pamatove miesto
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(
        products); //vytvarame novy list a teda neodkazujeme sa na rovnake pamatove miesto
  }

  bool get getIsLoading {
    return isLoading;
  }

  int get selectedProductIndex {
    return products.indexWhere((Product product) {
      return product.id == selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  String get selectedProductId {
    return selProductId;
  }

  Product get selectedProduct {
    if (selProductId != null) {
      return products.firstWhere((Product product) {
        return product.id == selProductId;
      });
    } else {
      return null;
    }
  }

  Future<bool> deleteProduct() {
    isLoading = true;
    final deletedProductId = selectedProduct.id;
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selProductId;
    });

    products.removeAt(selectedProductIndex); // tu som mal sel
    selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-project-products.firebaseio.com/products/${deletedProductId}.json?auth=${authenticatedUser.token}')
        .then((http.Response response) {
      isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    }); //vsetky erorr;
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://flutter-project-products.firebaseio.com/products.json?auth=${authenticatedUser.token}')
        .then<Null>((http.Response response) {
      isLoading = false;
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, bool>)
                    .containsKey(authenticatedUser.id));
        fetchedProductList.add(product);
      });
      products = onlyForUser ? fetchedProductList.where((Product product) {
        return product.userId == authenticatedUser.id;
      }).toList() :fetchedProductList;
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return;
    }); //vsetky erorr;
  }

  Future<bool> updateProduct(
      String title, String description, double price, String image) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2015/09/double-chocolate-ice-cream-bar.png',
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-project-products.firebaseio.com/products/${selectedProduct.id}.json?auth=${authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      products[selectedProductIndex] = updatedProduct;

      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    }); //vsetky erorr;
  }

  void selectProduct(String productId) {
    selProductId = productId;
    notifyListeners();
  }

  void toggleProductFavorite() async {
    final bool isCurrentlyFavorite = products[selectedProductIndex].isFavorite;
    final bool newFavoriteState = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);

    products[selectedProductIndex] = updatedProduct;

    notifyListeners();
    http.Response response;
    if (newFavoriteState) {
      response = await http.put(
          'https://flutter-project-products.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://flutter-project-products.firebaseio.com/products/${selectedProduct.id}/wishListUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteState);

      products[selectedProductIndex] = updatedProduct;

      notifyListeners();
    }

    selProductId = null;
  }

  void toogleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
