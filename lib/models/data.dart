class Data {
  int cart_id;
  String title;
  int product_id;
  int user_id;
  String image;
  String description;
  double price;
  int quantity;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['title'] = title;
    map['product_id'] = product_id;
    map['user_id'] = user_id;
    map['image'] = image;
    map['description'] = description;
    map['price'] = price;
    map['quantity'] = quantity;
    if (cart_id != null) {
      map['cart_id'] = cart_id;
    }
    return map;
  }
}