import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:localstorage/localstorage.dart';
import 'package:flutterShopping/models/Address.dart';
import 'package:flutterShopping/models/category.dart';
import 'package:flutterShopping/models/data.dart';
import 'package:flutterShopping/utilities/database_helper.dart';

mixin AppModel on Model {
  List<Item> _items = [];
  List<Data> _data = [];
  List<AddressModel> _address = [];
  List<Data> _cart = [];
  List<Category> _listCategoies = [];
  var _myOrder = [];
  List<String> _listCategoiesForAddProduct = [];
  var dataUser;
  String cartMsg = "";
  bool success = false;
  var _dbh = DatabaseHelper();
  Directory tempDir;
  String tempPath;
  final LocalStorage storage = new LocalStorage('app_data');

  List<Data> get itemListing => _data;
  List<Category> get categoryListing => _listCategoies;
  List<String> get listCategoiesForAddProduct => _listCategoiesForAddProduct;
  List<AddressModel> get listAddress => _address;
  List get myOrder => _myOrder;

  void setMyOrder(var list) {
    _myOrder = list;
  }

  getDataUser() async {
    dataUser = await SharedPreferences.getInstance();
    // print(dataUser.getInt('type'));
  }

  fetchLocalData() async {
    try {
      _data = [];
      List<DocumentSnapshot> list = await _dbh.getAllProducts();
      list.map((dd) {
        Data d = new Data();
        d.product_id = dd["product_id"];
        d.user_id = dd["user_id"];
        d.title = dd["title"];
        d.description = dd["description"];
        d.image = dd["image"];
        d.price = dd["price"];
        _data.add(d);
      }).toList();

      notifyListeners();
    } catch (e) {
      print("ERRR %%%");
      print(e);
    }
  }

  fetchAddresses(int id) async {
    try {
      _address = [];
      List<DocumentSnapshot> list = await _dbh.getDataAddeess(id);

      list.map((dd) {
        AddressModel d = new AddressModel();
        d.address_id = dd["address_id"];
        d.user_id = dd["user_id"];
        d.name = dd["name"];
        d.addressline = dd["addressline"];
        d.city = dd["city"];
        d.zip = dd["zip"];
        d.phone = dd["phone"];
        _address.add(d);
      }).toList();
      print("Scop Manage $listAddress");
      notifyListeners();
    } catch (e) {
      print("ERRR %%%");
      print(e);
    }
  }

  fetchCategories() async {
    try {
      _listCategoies = [];
      List<DocumentSnapshot> list = await _dbh.getCategories();
      print("Cart len ${list.length.toString()}");
      Category cat = new Category();
      cat.id = 0;
      cat.name = "All";
      _listCategoies.add(cat);
      list.map((dd) {
        Category cat = new Category();
        cat.id = dd["category_id"];
        cat.name = dd["category_name"];
        _listCategoies.add(cat);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  fetchCategeriesForAddProduct() async {
    //  print(1);
    try {
      _listCategoiesForAddProduct = [];
      List<DocumentSnapshot> list = await _dbh.getCategories();
     
      list.forEach((element) {
        _listCategoiesForAddProduct.add(element['category_name']);
      });
      //  print(_listCategoiesForAddProduct);
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  fetchProductByCategoryID(int id) async {
    // print(id);
    try {
      _data = [];
      List<DocumentSnapshot> list = await _dbh.getProductByCategoryID(id);

      list.map((dd) {
        Data d = new Data();
        d.product_id = dd["product_id"];
        d.title = dd["title"];
        d.description = dd["description"];
        d.image = dd["image"];
        d.price = dd["price"];
        _data.add(d);
      }).toList();
      // print(_data[0].title);
      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  fetchCartList(int id) async {
    try {
      // Get the records
      _cart = [];
      List<DocumentSnapshot> list = await _dbh.getDataCart(id);

      list.map((dd) {
        Data d = new Data();
        d.title = dd["title"];
        d.product_id = dd["product_id"];
        d.user_id = dd["user_id"];
        d.quantity = dd["quantity"];
        d.image = dd["image"];
        d.price = dd["price"];
        _cart.add(d);
      }).toList();

      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  // Cart Listing
  List<Data> get cartListing => _cart;

  // Add Cart
  void addCart(Data dd) async {
    await this.fetchCartList(dataUser.getInt('id'));
    int count = await _dbh.getNumberOfDocCart();
    count++;
    dd.cart_id = count;
    int _index = _cart.indexWhere((d) => d.cart_id == dd.cart_id);
    if (_index > -1) {
      success = false;
      cartMsg = "${dd.title.toUpperCase()} already added in Cart list.";
    } else {
      success = true;
      cartMsg = "${dd.title.toUpperCase()} successfully added in cart list.";
      dd.user_id = dataUser.getInt('id');
      await _dbh.InsertInCart(dd);
    }
  }

  RemoveCartDB(Data d) async {
    try {
      _dbh.removeProductFromCart(d.cart_id);
      int _index = _cart.indexWhere((dd) => dd.cart_id == d.cart_id);
      _cart.removeAt(_index);
      notifyListeners();
    } catch (e) {
      print("ERR rm cart${e}");
    }
  }

  // Remove Cart
  void removeCart(Data dd) {
    this.RemoveCartDB(dd);
  }
}

class Item {
  final String name;

  Item(this.name);
}
