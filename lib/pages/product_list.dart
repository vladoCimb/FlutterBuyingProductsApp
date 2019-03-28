import 'package:flutter/material.dart';
import './product_edit.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allproducts[index].id);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.products[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(model.allproducts[index].id);
                  model.deleteProduct();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(model.allproducts[index].image),
                      ),
                      title: Text(model.allproducts[index].title),
                      subtitle: Text(
                          '\$' + model.allproducts[index].price.toString()),
                      trailing: _buildEditButton(context, index, model)),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allproducts.length,
        );
      },
    );
  }
}
