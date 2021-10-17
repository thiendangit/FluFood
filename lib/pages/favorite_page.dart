import 'package:badges/badges.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FluFavorite',
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
    );
  }
}
