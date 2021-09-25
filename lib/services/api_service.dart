import 'package:flufood/models/customer.dart';
import 'package:flufood/services/api_contanst.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ApiService {
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
}
