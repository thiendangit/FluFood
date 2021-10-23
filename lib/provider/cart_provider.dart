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

  handlePrice(value) {
    // updateCounter(value.length);
  }

  Future<List<Cart>> getData() async {
    Future<List<Cart>> cartFuture = DBHelper.instance.getCartList();
    _cart = cartFuture;
    // update cart
    await cartFuture.then((value) => handlePrice(value));
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

  void updateCounter(int count) {
    _counter = count;
    setPrefItem();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    setPrefItem();
    notifyListeners();
  }

  void addTotalPrice(double totalPrice) {
    print('totalPrice ${totalPrice}');
    _totalPrice += totalPrice;
    setPrefItem();
    notifyListeners();
  }

  void updatePrice(double price) {
    _totalPrice = price;
    setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double totalPrice) {
    _totalPrice -= totalPrice;
    setPrefItem();
    notifyListeners();
  }

  void getTotalItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalPrice = prefs.getDouble(cartTotalPriceKey) ?? 0.0;
  }

  double getTotalPrice() {
    getTotalItem();
    return _totalPrice;
  }
}
