import 'package:flufood/models/category.dart';
import 'package:flufood/models/customer.dart';
import 'package:flufood/models/login.dart';
import 'package:flufood/services/api_contanst.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:dio/dio.dart';

class ApiService {
  int cookieTimeLife = 1200000;

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
      "second": cookieTimeLife,
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
      var res = await wooCommerceAPI.getAsync(ApiConfig.categories);
      categories = (res).map((e) => categoryFromJson(e)) as List<Category>;
      categories.toList();
      return categories;
    } catch (err) {
      print(err);
    }
    return categories;
  }
}
