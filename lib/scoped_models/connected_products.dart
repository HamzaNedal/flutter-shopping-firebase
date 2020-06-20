import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterShopping/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterShopping/models/Address.dart';
import 'package:flutterShopping/models/Product.dart';
import 'package:flutterShopping/models/orderItem.dart';
import 'package:flutterShopping/models/orders.dart';
import 'package:flutterShopping/models/user.dart';
import 'package:flutterShopping/utilities/database_helper.dart';
import '../models/Auth.dart';

var dbs = DatabaseHelper();

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
  List<Product> get getProducts {
    return List.from(_products);
  }

  Future<bool> addProduct(String title, String description, double price,
      String cagtegory, File image) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userAuth = await SharedPreferences.getInstance();
      var id = userAuth.getInt('id');
      final bytes = image.readAsBytesSync();
      String img64 = base64Encode(bytes);
      var resultID = await dbs.getCategoryIdByName(cagtegory);
      var count = await dbs.getNumberOfDocProducts();
      count++;
      await dbs.saveProduct(
          Product(count, id, resultID, title, description, price, img64));

      notifyListeners();
      _isLoading = false;
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, double price,
      File image, String cagtegory, int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final bytes = image.readAsBytesSync();
      String img64 = base64Encode(bytes);
      var categoryID = await dbs.getCategoryIdByName(cagtegory);
      final userAuth = await SharedPreferences.getInstance();
      var user_id =  userAuth.getInt('id');
      var result = await dbs.editProduct(id,
          Product(id, user_id, categoryID, title, description, price, img64));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Future<bool> deleteProduct(int id) async {
  //   final int deletedProductIndex =
  //       _products.indexWhere((product) => product.id == id);
  //   try {
  //     dbs.deleteProduct(id);
  //     _products.removeAt(deletedProductIndex);
  //     notifyListeners();

  //     return true;
  //   } catch (error) {
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<bool> addAddress(
      String name, String addressline, String city, int zip, int phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      var count = await dbs.getNumberOfDocAddress();
      count++;
      // print(count);
      final userAuth = await SharedPreferences.getInstance();
      var result = await dbs.saveAddress(AddressModel(
          address_id: count,
          user_id: userAuth.getInt('id'),
          name: name,
          addressline: addressline,
          city: city,
          zip: zip,
          phone: phone));
      print(result);
      notifyListeners();
      _isLoading = false;
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addOrder(int address) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userAuth = await SharedPreferences.getInstance();
      List<DocumentSnapshot> dataCart =
          await dbs.getDataCart(userAuth.getInt('id'));
      int count = await dbs.getNumberOfDocOrdres();
      count++;
      dataCart.forEach((data) async {
        await dbs.saveOrders(Orders(
            order_id: count,
            customer_id: data['user_id'],
            product_id: data['product_id'],
            order_status: 0));
        await dbs.saveOrdersItem(OrderItem(
            order_id: count,
            product_id: data['product_id'],
            user_id: data['user_id'],
            address_id: address,
            quantity: data['quantity']));
      });
      await dbs.removeProductFoeUserFromCart(userAuth.getInt('id'));

      notifyListeners();
      _isLoading = false;
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

mixin UserModel on ConnectedProductsModel {
  bool isAuthenticated = false;
  Future<SharedPreferences> getDataPreferences() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    return user;
  }

  Future<Map<dynamic, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login, int type]) async {
    _isLoading = true;
    notifyListeners();
    Map result;

    bool hasSucceeded = true;
    String message = 'Authenticated succeeded.';
    final SharedPreferences userAuth = await SharedPreferences.getInstance();
    if (mode == AuthMode.Login) {
      result = await dbs.login(email, password);
      print(result);
      if (result.length>0) {
        await userAuth.setBool('isAuthenticated', true);
        await userAuth.setInt('type', result['type']);
        await userAuth.setInt('id', result['id']);
        isAuthenticated = userAuth.getBool('isAuthenticated');
      } else {
        await userAuth.setBool('isAuthenticated', false);
        message = 'email or password incorrect';
        hasSucceeded = false;
      }
    } else {
      int count = await dbs.getNumberOfDoc();
      count++;
      User userReg = User(count, email, password, type);
      DocumentReference userDoc = await dbs.registerUser(userReg);
      userDoc.get().then((result) async {
        await userAuth.setBool('isAuthenticated', true);
        await userAuth.setInt('type', result['type']);
        await userAuth.setInt('id', result['id']);
      });
    }
    _isLoading = false;
    notifyListeners();
    return {'success': hasSucceeded, 'message': message};
  }

  Future logout(model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('id');
    preferences.remove('type');
    preferences.setBool('isAuthenticated', false);
    isAuthenticated = false;
    // print(model.myOrder);
    model.setMyOrder([]);
    
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
