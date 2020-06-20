class User {
  int id;
  String email;
  String password;
  int type;

  User(this.id,this.email,this.password,this.type);

  User.map(dynamic obj) {
    this.email = obj['email'];
    this.password = obj['password'];
    this.type = obj['type'];
  }

  String get _email => email;
  String get _password => password;
  int get _type => type;
  int get _id => id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['email'] = _email;
    map['password'] = _password;
    map['type'] = _type;
    if (id != null) {
      map['id'] = _id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.email = map['email'];
    this.password = map['password'];
    this.type = map['type'];
    
  }
}
