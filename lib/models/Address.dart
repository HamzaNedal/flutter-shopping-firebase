class AddressModel {
  int address_id;
  int user_id;
  String name;
  String addressline;
  String city;
  int zip;
  int phone;

  AddressModel({this.address_id,this.user_id, this.name, this.addressline, this.city, this.zip,
      this.phone});

  AddressModel.map(dynamic obj) {
    this.user_id = obj['user_id'];
    this.name = obj['name'];
    this.addressline = obj['addressline'];
    this.city = obj['city'];
    this.zip = obj['zip'];
    this.phone = obj['phone'];
  }

  String get _name => name;
  String get _addressline => addressline;
  String get _city => city;
  int get _zip => zip;
  int get _user_id => user_id;
  int get _phone => phone;
  int get _address_id => address_id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['user_id'] = _user_id;
    map['name'] = _name;
    map['addressline'] = _addressline;
    map['city'] = _city;
    map['zip'] = _zip;
    map['phone'] = _phone;
    if (address_id != null) {
      map['address_id'] = _address_id;
    }
    return map;
  }

  AddressModel.fromMap(Map<String, dynamic> map) {
    this.address_id = map['address_id'];
    this.user_id = map['user_id'];
    this.name = map['name'];
    this.addressline = map['addressline'];
    this.city = map['city'];
    this.zip = map['zip'];
    this.phone = map['phone'];
  }
}
