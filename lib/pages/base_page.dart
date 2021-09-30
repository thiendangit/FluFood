import 'package:flufood/utils/ProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
      body: ProgressHUD(isLoading: isLoading, child: pageUI()),
    );
  }

  Widget pageUI() {
    return Container();
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
      automaticallyImplyLeading: true,
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Icon(Icons.shopping_cart_sharp, color: Colors.white),
        SizedBox(width: 10),
      ],
    );
  }
}
