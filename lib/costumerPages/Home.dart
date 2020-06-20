import 'dart:convert';

import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:flutterShopping/models/category.dart';
import 'package:flutterShopping/models/data.dart';
import 'package:flutterShopping/scoped_models/main.dart';
import 'package:flutterShopping/widgets/sliderCustomer.dart';
import 'package:flutterShopping/widgets/sliderSeller.dart';
import "Cart.dart";
import "Details.dart";

class Home extends StatefulWidget {
  MainModel appModel;
  static final String route = "Home-route";

  Home({this.appModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    
    widget.appModel.fetchLocalData();
    widget.appModel.fetchCategories();
    super.initState();
  }

  Widget GridGenerate(List<Data> data, aspectRadtio) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: aspectRadtio),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(detail: data[index])));
                },
                child: Container(
                    height: 340.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          // BoxShadow(color: Colors.black12, blurRadius: 8.0)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 130.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Image.memory(
                                        base64Decode(
                                          data[index].image,
                                        ),
                                        fit: BoxFit.contain),

                                    // Image.network(data[index].image,fit: BoxFit.contain,),
                                  ),
                                ),
                                // Container(
                                //   child: data[index].fav ? Icon(Icons.favorite,size: 20.0,color: Colors.red,) : Icon(Icons.favorite_border,size: 20.0,),
                                // )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${data[index].title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "\$${data[index].price.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ));
        },
        itemCount: data.length,
      ),
    );
  }
  Widget categories(List<Category> cat) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cat.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                if (cat[index].id == 0) {
                  await model.fetchLocalData();
                } else {
                  await model.fetchProductByCategoryID(cat[index].id);
                }
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.only(top: 15.0, left: 5),
                child: Text(
                  "${cat[index].name}",
                  style: TextStyle(fontSize: 25),
                ),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12)
                    ]),
              ),
            );
          });
    });
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    // TODO: implement build
    return Scaffold(
       backgroundColor: Color(0xffe9e9e9),
      appBar: AppBar(
        title: Text("Home"),
        
        elevation: 0.0,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  onTap: () {
                    widget.appModel.fetchCartList(widget.appModel.dataUser.getInt('id'));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            ],
          )
        ],
      ),
    
      drawer: widget.appModel.dataUser.getInt('type') == 1 ?  BuildSideDrawerSeller(context) : BuildSideDrawerCustomer(context),
      body:
       ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return Column(children: <Widget>[
         
          Flexible(flex: 1, child: categories(model.categoryListing)),
          Flexible(
              flex: 8,
              child: GridGenerate(model.itemListing, (itemWidth / itemHeight))),
        ]);
      }),
    );
  }


}
