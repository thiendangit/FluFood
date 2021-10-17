import 'package:flufood/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WidgetCartTotal extends StatefulWidget {
  const WidgetCartTotal({Key? key}) : super(key: key);

  @override
  _WidgetCartTotalState createState() => _WidgetCartTotalState();
}

class _WidgetCartTotalState extends State<WidgetCartTotal> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
      return Visibility(
          visible: value.getTotalPrice() > 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sub total :',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                Text(
                  '\$' + ' ' + value.getTotalPrice().toStringAsFixed(2),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ));
    });
  }
}
