import 'package:flutter/material.dart';
import 'package:flutterShopping/widgets/sliderSeller.dart';

import './product_create.dart';
import './product_list.dart';

import '../widgets/ui_elements/logout_list_tile.dart';

import '../scoped_models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Manage Products'),
                bottom: TabBar(
                    // onTap: (x) async =>
                    //     // {await model.fetchCategeriesForAddProduct()},
                    tabs: <Widget>[
                      Tab(text: 'Create Product', icon: Icon(Icons.create)),
                      Tab(text: 'My Products', icon: Icon(Icons.list))
                    ])),
            drawer: BuildSideDrawerSeller(context),
            body: TabBarView(children: <Widget>[
              ProductCreatePage(),
              ProductListPage(model)
            ])));
  }
}
