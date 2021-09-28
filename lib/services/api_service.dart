import 'dart:convert';

import 'package:flufood/models/category.dart';
import 'package:flufood/models/customer.dart';
import 'package:flufood/models/login.dart';
import 'package:flufood/models/product.dart';
import 'package:flufood/services/api_contanst.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const int COOKIE_TIME_LIFE = 1200000;

  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
    url: dotenv.env['WOO_COMMERCE_URL']!,
    consumerKey: dotenv.env['CONSUMER_KEY']!,
    consumerSecret: dotenv.env['SECRET_KET']!,
  );

  Future<bool> createCustomer(CustomerModel model) async {
    bool ret = false;
    try {
      await wooCommerceAPI.postAsync(ApiConfig.customers, model.toJson());
      ret = true;
    } catch (err) {
      print(err);
      ret = false;
    }
    return ret;
  }

  Future<dynamic> loginCustomer(String username, String password) async {
    LoginResponseModel _loginResponseModel;
    var dio = Dio();
    var dateToSend = {
      "second": COOKIE_TIME_LIFE,
      "username": username,
      "password": password
    };
    try {
      var response = await dio.post(dotenv.env['WOO_COMMERCE_LOGIN_URL']!,
          data: dateToSend,
          options: new Options(headers: {
            Headers.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200 && response.data != null) {
        _loginResponseModel = LoginResponseModel.fromJson(response.data);
        return _loginResponseModel;
      }
    } on DioError catch (e) {
      print(e.error.toString());
      return null;
    }
    return null;
  }

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    try {
      List<dynamic> res = await wooCommerceAPI.getAsync(ApiConfig.categories);
      categories = (res).map((e) => categoryFromJson(json.encode(e))).toList();
      return categories;
    } catch (err) {
      print(err);
    }
    return categories;
  }

  Future<List<Product>> getProducts({String tagName = ""}) async {
    List<Product> products = [];
    var url = ApiConfig.products + (tagName != "" ? "?tag=$tagName" : "");
    try {
      List<dynamic> res = await wooCommerceAPI.getAsync(url);
      print(res.toString());
      products = (res).map((e) => productFromJson(json.encode(e))).toList();
      return products;
    } catch (err) {
      print(err);
    }
    return products;
  }
}
