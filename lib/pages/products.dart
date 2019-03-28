import 'package:flutter/material.dart';

import '../widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_listile.dart';
class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductsPage> {
  @override
  initState(){
    widget.model.fetchProducts();
    super.initState();
  }
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
           
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildMyProductsList(){
    return ScopedModelDescendant(builder: (BuildContext context, Widget widget, MainModel model){
      Widget content =Center(child: Text('No products found!'));
      if(model.displayedProducts.length > 0 && !model.isLoading){
        content =Products();
      } else if (model.isLoading){
        content = Center(child: CircularProgressIndicator());
      }
      
      return RefreshIndicator(onRefresh: model.fetchProducts //alebo normalne (){model.fetchProducts()}
      ,child: content);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toogleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildMyProductsList(),
    );
  }
}
