import "package:flutter/material.dart";
import 'package:flutterShopping/utilities/database_helper.dart';

class DetailsOrder extends StatefulWidget {
  static final String route = "Home-route";
  var data;
  DetailsOrder({this.data});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsOrderState();
  }
}

class DetailsOrderState extends State<DetailsOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int count = 1;
  PageController _controller;
  int active = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Order Details"),
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Text(
                  "Client Name : ",
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Text(
                  "${widget.data['name']}",
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Text(
                  "Address lane : ",
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Text(
                  "${widget.data['Address_lane']}",
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Text(
                  "Product list : ",
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Text(
                  "${widget.data['product_name']}",
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: height - 381),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: widget.data['order_status'] == 0
                      ? RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            await DatabaseHelper()
                                .updateOrderStatus(widget.data['order_id'], 1);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        )
                      : RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Accepted",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ))
            ],
          )),
    );
  }
}
