import 'dart:convert';
import 'package:flufood/models/product.dart';

Cart productFromJson(String str) => Cart.fromJson(json.decode(str));

String productToJson(Cart data) => json.encode(data.toJson());

class PriceResponse {
  String? price = '0';
  String? salesPrice = '0';

  PriceResponse({required this.price, required this.salesPrice});
}

class Cart {
  Cart({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.regular_price,
    required this.sale_price,
    required this.images,
    required this.quantity,
  });

  int id;
  String name;
  String sku;
  String? price;
  String? regular_price;
  String sale_price;
  String? images;
  int? quantity;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      id: json["id"],
      name: json["name"],
      sku: json["sku"],
      price: json["price"],
      regular_price: json["regular_price"],
      sale_price:
          json["sale_price"] != '' ? json["sale_price"] : json["regular_price"],
      images: json["images"],
      quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "price": price,
        "regular_price": regular_price.toString(),
        "sale_price": sale_price,
        "images": images != null ? images : '',
        "quantity": quantity
      };

  calculateDiscount() {
    if (this.regular_price != '') {
      double regularPrice = double.parse(this.regular_price as String);
      double salesPrice =
          this.sale_price != '' ? double.parse(this.sale_price) : regularPrice;
      double discount = regularPrice - salesPrice;
      double disPercent = (discount / regularPrice) * 100;
      return disPercent.round();
    } else {
      return 0.0;
    }
  }

  PriceResponse calculatePrice() {
    var realPrice = this.sale_price != ""
        ? this.sale_price
        : this.regular_price != ""
            ? this.regular_price
            : this.price != ""
                ? this.price
                : '0';
    var salesPrice = this.regular_price != ""
        ? this.regular_price
        : this.price != ""
            ? this.price
            : '0';
    var salesPriceDisplay = salesPrice.toString() != realPrice.toString()
        ? salesPrice.toString()
        : '0';
    return PriceResponse(price: realPrice, salesPrice: salesPriceDisplay);
  }
}
