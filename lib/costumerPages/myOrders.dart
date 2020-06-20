import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterShopping/utilities/database_helper.dart';
import 'package:flutterShopping/widgets/ui_elements/adaptive_progress_indicator.dart';
import "package:scoped_model/scoped_model.dart";
import 'package:flutterShopping/models/data.dart';
import 'package:flutterShopping/scoped_models/main.dart';
import 'package:flutterShopping/widgets/sliderCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget{
  static final String route = "MyOrders-route";
  
       
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyOrdersState();
  }
}

class MyOrdersState extends State<MyOrders>{
    var orders = [];
  getData() async {
    var user = await SharedPreferences.getInstance();
    var dbs = DatabaseHelper();
    await dbs.getOrdersForCustomer(user.getInt('id'));
    orders = dbs.dataOrderCustomer;
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }
  Widget generateCart(dynamic d){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey[100],
                    width: 1.0
                ),
              top: BorderSide(
                  color: Colors.grey[100],
                  width: 1.0
              ),
            )
        ),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0
                  )
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)
                ),                  
                image: DecorationImage(
                  image: MemoryImage(base64Decode(d['image'])) ,fit: BoxFit.fill
                  )
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0,left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(d['title'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            child:
                            
                            d['order_status'] == 1 ? Text(  "Accepted" ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0,color: Colors.green[300]),)
                             : Text("Pending",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0,color: Colors.yellow[300]),)
                        )
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Text("Price ${d['price'].toString()} x ${d['quantity'].toString()}"),
                    // Text("Quantity ${d.quantity.toString()}"),

                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar:AppBar(
        elevation: 0.0,
        title: Text("Orders"),
      ),
      drawer:BuildSideDrawerCustomer(context),
      backgroundColor: Colors.white,
      body:Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey[300],
                    width: 1.0
                )
            )
        ),
        child: 
         ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model){
                 if (orders.length == 0) {
                Timer.periodic(new Duration(seconds: 1), (timer) {
                  if (orders.length > 0) {
                    model.setMyOrder(orders);
                     timer.cancel();
                    setState(() {});
                  }
                });
               
              } 
           return 
           Column(
             children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: model.myOrder.length == 0
                        ? [Center(child: AdaptiveProgressIndicator())]
                        : model.myOrder.map((d) => generateCart(d)).toList(),
                  // children: <Widget>[
                  //   Container()
                  // ],
                ),
                 
             ],
           );
         
          },
        ),
      )
    );
  }
  
}
