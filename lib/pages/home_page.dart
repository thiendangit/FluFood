import 'package:badges/badges.dart';
import 'package:flufood/pages/cart_page.dart';
import 'package:flufood/pages/dashboard_page.dart';
import 'package:flufood/pages/favorite_page.dart';
import 'package:flufood/pages/login_page.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flufood/utils/cart_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    CartPage(),
    FavoritePage(),
    LoginPage(),
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(CartIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CartIcons.cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(CartIcons.favorites), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(CartIcons.account), label: 'Account'),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }
}
