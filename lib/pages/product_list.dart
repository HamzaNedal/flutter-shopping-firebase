import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterShopping/utilities/database_helper.dart';
import '../scoped_models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products1 = [];
  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    var user = await SharedPreferences.getInstance();

    var dbs = DatabaseHelper();
    products1 = await dbs.getProductsSeller(user.getInt('id'));
    setState(() {
     
    });
  }

  void _buildShowAlertDialog(
      BuildContext context, int id, Function deleteProduct) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Product.'),
              content: Text('Are you sure?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('CANCEL')),
                FlatButton(
                    onPressed: () {
                      deleteProduct(id);
                      Navigator.of(context).pop();
                    },
                    child: Text('CONFIRM'))
              ]);
        });
  }

  Widget _buildEditButton(BuildContext context, int id,MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
         
          model.fetchCategeriesForAddProduct();
          return Navigator.pushNamed(context, '/product/edit/$id');
        });
  }

  Widget _buildProductsList(MainModel model) {
    return products1.length > 0
        ? ListView.builder(
            itemCount: products1.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(products1[index]['product_id'].toString()),
                // onDismissed: (DismissDirection direction) {
                //   if (direction == DismissDirection.endToStart) {
                //     _buildShowAlertDialog(context,
                //         products1[index]['product_id'], model.deleteProduct);
                //   }
                // },
                background: Container(color: Colors.red),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: CircleAvatar(
                          child: Image.memory(
                            base64Decode(
                              products1[index]['image'],
                            ),
                          ),
                        ),
                        title: Text(products1[index]['title']),
                        subtitle: Text('\$ ${products1[index]['price']}',
                            style: TextStyle(color: Colors.green)),
                        trailing: _buildEditButton(
                            context, products1[index]['product_id'],model)),
                    Divider(height: 2.0)
                  ],
                ),
              );
            })
        : Center(child: Text('No products added to your list yet!'));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          
      return _buildProductsList(model);
    });
  }
}
