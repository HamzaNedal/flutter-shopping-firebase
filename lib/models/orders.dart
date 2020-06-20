class Orders {
  int order_id;
  int customer_id;
  int product_id;
  int order_status;
 

  Orders({this.order_id,this.customer_id, this.product_id, this.order_status});

  Orders.map(dynamic obj) {
    this.customer_id = obj['customer_id'];
    this.product_id = obj['product_id'];
    this.order_status = obj['order_status'];
  }

  int get _customer_id => customer_id;
  int get _product_id => product_id;
  int get _order_id => order_id;
  int get _order_status => order_status;
 

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['customer_id'] = _customer_id;
    map['product_id'] = _product_id;
    map['order_status'] = _order_status;
    if (order_id != null) {
      map['order_id'] = _order_id;
    }
    return map;
  }


}
