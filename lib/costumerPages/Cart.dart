import 'dart:convert';
import 'package:flutter/material.dart';
import "package:scoped_model/scoped_model.dart";
import 'package:flutterShopping/models/data.dart';
import 'package:flutterShopping/scoped_models/main.dart';

class Cart extends StatefulWidget{
  static final String route = "Cart-route";
  
       
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart>{
  
  Widget generateCart(Data d){
      print(d.title);
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
                  image: MemoryImage(base64Decode(d.image)) ,fit: BoxFit.fill
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
                          child: Text(d.title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: ScopedModelDescendant<MainModel>(
                              builder: (cotext,child,model){
                                return InkResponse(
                                    onTap: (){
                                      model.removeCart(d);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.remove_circle,color: Colors.red,),
                                    )
                                );
                              },
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Text("Price ${d.price.toString()} x ${d.quantity.toString()}"),
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
        title: Text("Cart List"),
      ),
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
            
           return 
           Column(
             children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: model.cartListing.map((d)=> generateCart(d)).toList(),
                ),
                  ScopedModelDescendant<MainModel>(
                  builder: (context, child, model) {
                    return RaisedButton(

                      color: Colors.deepOrange,
                      onPressed: () {
                        model.fetchAddresses(model.dataUser.getInt('id'));
                        // print(model.cartListing);
                        Navigator.pushNamed(context, '/address');
                        // widget.detail.quantity = count;
                        // model.addCart(widget.detail);
                        // Timer(Duration(milliseconds: 500), () {
                        //   showCartSnak(model.cartMsg, model.success);
                        // });
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )
             ],
           );
         
          },
        ),
      )
    );
  }
  
}
