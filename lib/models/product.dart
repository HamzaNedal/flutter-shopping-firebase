
class Product {
  int product_id;
  String title;
  String description;
  double price;
  String image;
  int category_id;
  int user_id;

  Product(this.product_id,this.user_id,this.category_id,this.title,this.description,this.price,this.image);

  Product.map(dynamic obj) {
    this.title = obj['title'];
    this.description = obj['description'];
    this.price = obj['price'];
    this.category_id = obj['category_id'];
    this.user_id = obj['user_id'];
    this.image = obj['image'];
  }

  String get _title => title;
  String get _description => description;
  double get _price => price;
  String get _image => image;
  int get _category_id => category_id;
  int get _user_id => user_id;
  int get _id => product_id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['price'] = _price;
    map['category_id'] = _category_id;
    map['user_id'] = _user_id;
    map['image'] = _image;
    
    if (product_id != null) {
      map['product_id'] = _id;
    }
    return map;
  }

  Product.fromMap(Map<String, dynamic> map){
    this.product_id = map['product_id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.category_id = map['category_id'];
     this.user_id = map['user_id'];
    this.image = map['image'];
    
  }
}
