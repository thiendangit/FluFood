import 'package:flufood/models/cart.dart';
import 'package:flufood/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String cartCounterKey = 'cart_counter';
String cartTotalPriceKey = 'cart_total_price';

class CartProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;
  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;

  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData() async {
    _cart = DBHelper.instance.getCartList();
    return _cart;
  }

  void setPrefItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(cartCounterKey, _counter);
    prefs.setDouble(cartTotalPriceKey, _totalPrice);
    notifyListeners();
  }

  void getPrefItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(cartCounterKey) ?? 0;
    _totalPrice = prefs.getDouble(cartTotalPriceKey) ?? 0.0;
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    setPrefItem();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    setPrefItem();
    notifyListeners();
  }

  void addTotalPrice(double totalPrice) {
    _totalPrice += totalPrice;
    setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double totalPrice) {
    _totalPrice -= totalPrice;
    setPrefItem();
    notifyListeners();
  }

  double getTotalPrice() {
    getPrefItem();
    return _totalPrice;
  }
}
