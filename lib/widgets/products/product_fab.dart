import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'contact',
                mini: true,
                onPressed: () {},
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'favorite',
                mini: true,
                onPressed: () {
                  model.toggleProductFavorite();
                },
                child: Icon(
                    model.selectedProduct.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red),
              ),
            ),
            FloatingActionButton(
              heroTag: 'options',
              onPressed: () {},
              child: Icon(Icons.more_vert),
            ),
          ],
        );
      },
    );
  }
}
