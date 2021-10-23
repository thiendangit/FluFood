import 'package:badges/badges.dart';
import 'package:flufood/models/cart.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flufood/utils/custom_stepper.dart';
import 'package:flufood/utils/db_helper.dart';
import 'package:flufood/widgets/widget_cart_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> res) {
                  if (res.hasData && res.data != null) {
                    if (res.data!.isEmpty) {
                      return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/empty_cart.png'),
                                    height: 250,
                                    width: 250,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Explore products you are like !.',
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              ],
                            ),
                          ));
                    }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  DBHelper.instance
                                                      .delete(product.id);
                                                  cart.removeCounter();
                                                  int qty = int.parse(product
                                                      .quantity
                                                      .toString());
                                                  double newTotal =
                                                      (double.parse(product
                                                              .calculatePrice()
                                                              .price
                                                              .toString()) *
                                                          (int.parse(
                                                              qty.toString())));
                                                  cart.removeTotalPrice(
                                                      newTotal);
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              CustomStepper(
                                                  lowerLimit: 0,
                                                  upperLimit: 20,
                                                  value: (int.parse(product
                                                      .quantity
                                                      .toString())),
                                                  iconSize: 22.0,
                                                  stepValue: 1,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      DBHelper.instance
                                                          .updateQuantity(
                                                              product.id,
                                                              int.parse(value
                                                                  .toString()))
                                                          .then((_value) {
                                                        cart.updateCounter(
                                                            res.data!.length);
                                                        if ((int.parse(value
                                                                .toString())) >
                                                            (int.parse(product
                                                                .quantity
                                                                .toString()))) {
                                                          // cart.addTotalPrice(
                                                          //     double.parse(product
                                                          //         .calculatePrice()
                                                          //         .price
                                                          //         .toString()));
                                                          cart.updatePrice(0);
                                                        } else {
                                                          cart.removeTotalPrice(
                                                              double.parse(product
                                                                  .calculatePrice()
                                                                  .price
                                                                  .toString()));
                                                        }
                                                      });
                                                    });
                                                  })
                                            ],
                                          )
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
                }),
            WidgetCartTotal()
          ],
        ),
      ),
    );
  }
}
