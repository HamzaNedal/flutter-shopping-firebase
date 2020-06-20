import 'package:scoped_model/scoped_model.dart';
import 'package:flutterShopping/models/Address.dart';
import 'package:flutterShopping/models/data.dart';
import 'package:flutterShopping/models/orderItem.dart';
import 'package:flutterShopping/models/orders.dart';
import 'package:flutterShopping/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterShopping/models/Product.dart';

class DatabaseHelper extends Model {
  Future<DocumentReference> registerUser(User user) async {
    return await Firestore.instance.collection('users').add(user.toMap());
  }

  getNumberOfDoc() async {
    int count = 0;
    await Firestore.instance.collection('users').getDocuments().then((value) {
      count = value.documents.length;
    });
    return count;
  }

  Future<Map> login(String email, String password) async {
    Map<String, dynamic> map = {};
    await Firestore.instance
        .collection('users')
        .where("email", isEqualTo: "$email")
        .where('password', isEqualTo: "$password")
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        map['id'] = data['id'];
        map['email'] = data['email'];
        map['type'] = data['type'];
      });
    });
    return map;
  }

  getNumberOfDocProducts() async {
    int count = 0;
    await Firestore.instance
        .collection('products')
        .getDocuments()
        .then((value) {
      count = value.documents.length;
    });
    return count;
  }

  Future<DocumentReference> saveProduct(Product product) async {
    return await Firestore.instance.collection('products').add(product.toMap());
  }

  Future<dynamic> getProductsSeller(int id) async {
    List result = [];
    await Firestore.instance
        .collection('products')
        .where('user_id', isEqualTo: id)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        result.add(element);
      });
    });
    return result;
  }

  Future<List> getProductByID(int id) async {
    List list = [];
    await Firestore.instance
        .collection('products')
        .where('product_id', isEqualTo: id)
        .getDocuments()
        .then((value) => list = value.documents);

    return list;
  }

  Future<dynamic> getProductByCategoryID(int id) async {
    List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('products')
        .where('category_id', isEqualTo: id)
        .getDocuments()
        .then((value) {
      result = value.documents;
    });
    return result;
  }

  Future<dynamic> getAllProducts() async {
    List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('products')
        .getDocuments()
        .then((value) {
      result = value.documents;
    });
    return result;
  }

  Future<int> editProduct(int id, Product product) async {
    String documentID = "";
    await Firestore.instance
        .collection('products').where('product_id',isEqualTo: id)
        .getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            documentID = element.documentID;
          });
    });
    await Firestore.instance
        .collection('products')
        .document(documentID)
        .updateData(product.toMap());
  }

  // Future<int> deleteProduct(int id) async {
  //   // var dbs = await db;
  //   // int result =
  //   //     await dbs.rawDelete("DELETE FROM products WHERE product_id = $id");
  //   // return result;
  // }

  // Future<int> insertCategory(String name) async {
  //   // var dbregister = await db;
  //   // int result = await dbregister
  //   //     .rawInsert("INSERT INTO categories (category_name) VALUES ('$name')");
  //   // return result;
  // }

  Future<dynamic> getCategories() async {
    List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('categories')
        .getDocuments()
        .then((value) {
      result = value.documents;
    });
    return result;
  }

  Future<int> getCategoryIdByName(String name) async {
    int result = 0;
    await Firestore.instance
        .collection('categories')
        .where('category_name', isEqualTo: name)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        result = element['category_id'];
      });
    });
    return result;
  }

  getNumberOfDocCart() async {
    int count = 0;
    await Firestore.instance.collection('cart').getDocuments().then((value) {
      count = value.documents.length;
    });
    return count;
  }

  Future<dynamic> InsertInCart(Data d) async {
    return await Firestore.instance.collection('cart').add(d.toMap());
  }

  Future<dynamic> getDataCart(int id) async {
    List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('cart')
        .where('user_id', isEqualTo: id)
        .getDocuments()
        .then((value) {
      result = value.documents;
    });
    return result;
  }

  Future<int> removeProductFoeUserFromCart(int id) async {
    await Firestore.instance
        .collection('cart')
        .where('user_id', isEqualTo: id)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              Firestore.instance
                  .collection("cart")
                  .document(element.documentID)
                  .delete();
            }));
  }

  Future<void> removeProductFromCart(int id) async {
    // List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('cart')
        .where('cart_id', isEqualTo: id)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              Firestore.instance
                  .collection("cart")
                  .document(element.documentID)
                  .delete();
            }));
  }

  getNumberOfDocAddress() async {
    int count = 0;
    await Firestore.instance.collection('address').getDocuments().then((value) {
      count = value.documents.length;
    });
    return count;
  }

  Future<dynamic> saveAddress(AddressModel addess) async {
    return await Firestore.instance.collection('address').add(addess.toMap());
  }

  Future<List> getDataAddeess(int id) async {
    List<DocumentSnapshot> result = [];
    await Firestore.instance
        .collection('address')
        .where('user_id', isEqualTo: id)
        .getDocuments()
        .then((value) {
      result = value.documents;
    });
    return result;
  }

  getNumberOfDocOrdres() async {
    int count = 0;
    await Firestore.instance.collection('orders').getDocuments().then((value) {
      count = value.documents.length;
    });
    return count;
  }

  Future<dynamic> saveOrders(Orders order) async {
    return await Firestore.instance.collection('orders').add(order.toMap());
  }

  Future<dynamic> saveOrdersItem(OrderItem order_item) async {
    return await Firestore.instance
        .collection('order_items')
        .add(order_item.toMap());
  }

  List<Map<String, dynamic>> dataOrderCustomer = [];

  Future<Map> getOrdersForCustomer(int id) async {
    await Firestore.instance
        .collection('orders')
        .where('customer_id', isEqualTo: id)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) async {
        Map<String, dynamic> dataOrderMap = {};
        await Firestore.instance
            .collection('products')
            .where('product_id', isEqualTo: element['product_id'])
            .getDocuments()
            .then((valuePro) {
          valuePro.documents.forEach((elementPro) {
            dataOrderMap['price'] = elementPro['price'];
            dataOrderMap['description'] = elementPro['description'];
            dataOrderMap['title'] = elementPro['title'];
            dataOrderMap['image'] = elementPro['image'];
          });
        });

        await Firestore.instance
            .collection('order_items')
            .where('order_id', isEqualTo: element['order_id'])
            .where('user_id', isEqualTo: id)
            .getDocuments()
            .then((valueOrderItem) {
          valueOrderItem.documents.forEach((elementOrderItem) {
            // dataOrder.add(element['quantity']);
            dataOrderMap['quantity'] = elementOrderItem['quantity'];
          });
        });
        dataOrderMap['order_status'] = element['order_status'];
        dataOrderCustomer.add(dataOrderMap);
        // return dataOrder;
      });
    });
  }

  List<Map<String, dynamic>> dataOrderSeller = [];
  Future<List> getOrdersForSeller(int user_id) async {
    await Firestore.instance
        .collection('order_items')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) async {
        Map<String, dynamic> dataOrderMap = {};
        await Firestore.instance
            .collection('products')
            .where('user_id', isEqualTo: user_id)
            .where('product_id', isEqualTo: element['product_id'])
            .getDocuments()
            .then((valuePro) {
          if (valuePro.documents.length > 0) {
            valuePro.documents.forEach((elementPro) async {
              dataOrderMap['price'] = elementPro['price'];
              dataOrderMap['description'] = elementPro['description'];
              dataOrderMap['title'] = elementPro['title'];
              dataOrderMap['image'] = elementPro['image'];

              await Firestore.instance
                  .collection('orders')
                  .where('product_id', isEqualTo: elementPro['product_id'])
                  .getDocuments()
                  .then((valueOrder) {
                valueOrder.documents.forEach((elementOreder) async {
                  dataOrderMap['order_status'] = elementOreder['order_status'];
                  dataOrderMap['order_id'] = elementOreder.documentID;
                });
              });

              await Firestore.instance
                  .collection('address')
                  .where('address_id', isEqualTo: element['address_id'])
                  .getDocuments()
                  .then((valueAddress) {
                valueAddress.documents.forEach((elementAddress) {
                  dataOrderMap['city'] = elementAddress['city'];
                  dataOrderMap['name'] = elementAddress['name'];
                  dataOrderMap['addressline'] = elementAddress['addressline'];
                });
                dataOrderMap['quantity'] = element['quantity'];

                dataOrderSeller.add(dataOrderMap);
              });
            });
          }
        });

        // return dataOrder;
      });
    });
  }

  Future<void> updateOrderStatus(String id, int order_status) async {
    Firestore.instance
        .collection('orders')
        .document("$id")
        .updateData({'order_status': order_status});
  }
}
