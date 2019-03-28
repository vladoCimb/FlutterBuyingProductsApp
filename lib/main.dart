import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './models/product.dart';

import './scoped-models/products.dart';

import './scoped-models/main.dart';
import 'package:map_view/map_view.dart';

import './shared/adaptive_theme.dart';

main() {
  //debugPaintSizeEnabled = true;
  //debugPaintPointersEnabled = true;
  MapView.setApiKey('AIzaSyBLLMgJn2PEtrfw7c1tWeiv961mmMaWyBU');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {git
  final MainModel model = MainModel(); //tu by malo byt_model
  bool isAuthenticatedB = false;

  @override
  void initState() {
    model.autoAuthenticate();
    model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        isAuthenticatedB = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp( //!_isAuthenticated ? MaterialApp() : ak chceme zobrazovat prihlasenym nieco ine ako neprihlasenym
        //debugShowMaterialGrid: true, //ukaze kocky kde je co umiestnene pekne
        theme: getADaptiveThemeData(context),
        //home: AuthPage(), nemoyzeme pouzivat home a aj / lebo obidva oznacuju home page takye bud home: alebo routes '/'
        routes: {
          '/': (BuildContext context) =>
              !isAuthenticatedB  ? AuthPage() : ProductsPage(model),
          '/admin': (BuildContext context) => !isAuthenticatedB  ? AuthPage() : ProductsAdminPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!isAuthenticatedB){
            return MaterialPageRoute<bool>(builder: (BuildContext context) => AuthPage(),);
          }
          //executnute ked pouzijeme navigate podla mena ale neni registrovane v routes
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                model.allproducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              //materialpageround prepinanie medzi screenmi pomocou animiacii  CupertinoPageRoute{swipovanie}
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          //odchztavanie named routou ktore neprejdu v Ongenerateroute
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model));
        },
      ),
    );
  }
}
