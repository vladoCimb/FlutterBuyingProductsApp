import 'package:flutter/material.dart';

import 'dart:async';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';

import '../widgets/products/address_tag.dart';

import '../scoped-models/main.dart';

import '../models/product.dart';

import '../widgets/products/product_fab.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  // _showWarningDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Are you sure?'),
  //           content: Text('This action cannot be undone'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Discard'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('Continue'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.pop(context, true);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
  Widget _buildAdressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AddressTag('Praha 8, Zarybska 28'),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('back button pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 10.0, right: 20.0, left: 20.0, bottom: 5.0),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Image.network(product.image),
              ),
            ),
            _buildAdressPriceRow(product.price),
            TitleDefault(product.title),
            Container(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        floatingActionButton: ProductFab(product),
      ),
    );
  }
}
