class OrderItem {
  int order_id;
  int user_id;
  int product_id;
  int address_id;
  int quantity;
 

  OrderItem({this.order_id,this.user_id, this.product_id,this.address_id, this.quantity});

  OrderItem.map(dynamic obj) {
    this.user_id = obj['user_id'];
    this.product_id = obj['product_id'];
    this.address_id = obj['address_id'];
    this.quantity = obj['quantity'];
  }

  int get _user_id => user_id;
  int get _product_id => product_id;
  int get _order_id => order_id;
  int get _address_id => address_id;
  int get _quantity => quantity;
 

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['user_id'] = _user_id;
    map['product_id'] = _product_id;
    map['address_id'] = _address_id;
    map['quantity'] = _quantity;
    if (order_id != null) {
      map['order_id'] = _order_id;
    }
    return map;
  }


}
