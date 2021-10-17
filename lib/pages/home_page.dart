import 'package:badges/badges.dart';
import 'package:flufood/pages/dashboard_page.dart';
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
    LoginPage(),
  ];
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
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

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'FluFood',
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
    );
  }
}
