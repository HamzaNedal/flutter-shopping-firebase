import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterShopping/costumerPages/myOrders.dart';
import 'package:flutterShopping/pages/oreders.dart';
import 'package:flutterShopping/utilities/database_helper.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/product_edit.dart';
import './scoped_models/main.dart';
import 'costumerPages/Cart.dart';
import 'costumerPages/Details.dart';
import 'costumerPages/Home.dart';
import 'costumerPages/address.dart';
import 'costumerPages/address_create.dart';

void main() {
//  MapView.setApiKey(apiKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user;
  final MainModel _model = MainModel();
  // _model.
  // bool _isAuthenticated = false;
  // session() async {
  //   user = await _model.isAuthenticated;
  //   _isAuthenticated = user.getBool('isAuthenticated') == null
  //       ? false
  //       : user.getBool('isAuthenticated');
  // }

  createDatabase() async {
    // var dbs = DatabaseHelper();
    // dbs.db;
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          title: 'Shopper App Flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blue,
            buttonColor: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (BuildContext context) {
              // print(_model.isAuthenticated);
              _model.getDataUser();
              return !_model.isAuthenticated ? AuthPage() : Home(appModel: _model);
            },
            '/admin': (BuildContext context) {
              return !_model.isAuthenticated ? AuthPage() : ProductsAdminPage(_model);
            },
            '/details': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : Details(),
            '/cart': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : Cart(),
            '/address': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : Address(),
            '/add-address': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : AddAddress(),
            '/my-orders': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : MyOrders(),
            '/orders': (BuildContext context) =>
                !_model.isAuthenticated ? AuthPage() : Orders(),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_model.isAuthenticated) {
              return MaterialPageRoute(
                  builder: (BuildContext context) => AuthPage());
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            int _id;
            if (pathElements[1] == 'product') {
              if (pathElements[2] == 'edit') {
                print(pathElements);
                _id = int.parse(pathElements[3]);
                return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        !_model.isAuthenticated ? AuthPage() : ProductEditPage(_id));
              } else {
                _id = int.parse(pathElements[2]);
                print(_id);
                // return MaterialPageRoute<bool>(
                //     builder: (BuildContext context) =>
                //         !_model.isAuthenticated ? AuthPage() : ProductPage(_id));
              }
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(builder: (BuildContext context) {
              _model.getDataUser();
              !_model.isAuthenticated ? AuthPage() : Home(appModel: _model);
            });
          }),
    );
  }
}
