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
    required this.regularPrice,
    required this.salePrice,
    required this.images,
    required this.quantity,
  });

  int id;
  String name;
  String sku;
  String? price;
  String? regularPrice;
  String salePrice;
  List<ImageType>? images;
  int? quantity;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      id: json["id"],
      name: json["name"],
      sku: json["sku"],
      price: json["price"],
      regularPrice: json["regular_price"],
      salePrice:
          json["sale_price"] != '' ? json["sale_price"] : json["regular_price"],
      images: List<ImageType>.from(
          json["images"].map((x) => ImageType.fromJson(x))),
      quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "price": price,
        "regular_price": regularPrice.toString(),
        "sale_price": salePrice,
        "images": images != null
            ? List<dynamic>.from(images!.map((x) => x.toJson()))
            : null,
        "quantity": quantity
      };

  calculateDiscount() {
    if (this.regularPrice != '') {
      double regularPrice = double.parse(this.regularPrice as String);
      double salesPrice =
          this.salePrice != '' ? double.parse(this.salePrice) : regularPrice;
      double discount = regularPrice - salesPrice;
      double disPercent = (discount / regularPrice) * 100;
      return disPercent.round();
    } else {
      return 0.0;
    }
  }

  PriceResponse calculatePrice() {
    var realPrice = this.salePrice != ""
        ? this.salePrice
        : this.regularPrice != ""
            ? this.regularPrice
            : this.price != ""
                ? this.price
                : '0';
    var salesPrice = this.regularPrice != ""
        ? this.regularPrice
        : this.price != ""
            ? this.price
            : '0';
    var salesPriceDisplay = salesPrice.toString() != realPrice.toString()
        ? salesPrice.toString()
        : '0';
    return PriceResponse(price: realPrice, salesPrice: salesPriceDisplay);
  }
}
