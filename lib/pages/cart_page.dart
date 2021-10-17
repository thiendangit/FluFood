import 'package:badges/badges.dart';
import 'package:flufood/models/cart.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FluCart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        actions: [
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 10),
          Center(
            child: Badge(
              position: BadgePosition.topEnd(top: -15),
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, _) {
                  return Text(
                    value.counter.toString(),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
              animationDuration: Duration(microseconds: 300),
              badgeColor: Colors.blue,
              child: Icon(Icons.shopping_cart_sharp, color: Colors.white),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> res) {
                print(res.hasData);
                if (res.hasData && res.data != null) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: res.data!.length,
                          itemBuilder: (context, index) {
                            Cart product = res.data![index];
                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(
                                                product.images.toString())),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '\$' +
                                                  ' ' +
                                                  product
                                                      .calculatePrice()
                                                      .price
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        )),
                                        TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors
                                                  .redAccent, // foreground
                                              padding: EdgeInsets.all(15),
                                            ),
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
                } else {
                  return Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ));
                }
              })
        ],
      ),
    );
  }
}