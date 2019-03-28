import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/cupertino.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    print('Products widget builds');
    Widget productCards = Center(
      child: Text('No products found, pleas add some'),
    );

    if (products.length > 0) {
      productCards = ListView.builder(
        //listview ked ich je iba par a vieme kolko bey .builder a ma children
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    }

    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('Products widget builds');
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child, MainModel model){
      return _buildProductList(model.displayedProducts);
    },);
  }
}
