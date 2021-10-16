import 'dart:convert';

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
  });

  int id;
  String name;
  String sku;
  String? price;
  String? regularPrice;
  String salePrice;
  List<ImageType>? images;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"] != ''
            ? json["sale_price"]
            : json["regular_price"],
        images: List<ImageType>.from(
            json["images"].map((x) => ImageType.fromJson(x))),
      );

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

class ImageType {
  ImageType({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    required this.alt,
    required this.position,
  });

  dynamic id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String src;
  String name;
  String alt;
  dynamic position;

  factory ImageType.fromJson(Map<String, dynamic> json) => ImageType(
        id: json["id"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateCreatedGmt: DateTime.parse(json["date_created_gmt"]),
        dateModified: DateTime.parse(json["date_modified"]),
        dateModifiedGmt: DateTime.parse(json["date_modified_gmt"]),
        src: json["src"],
        name: json["name"],
        alt: json["alt"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated.toIso8601String(),
        "date_created_gmt": dateCreatedGmt.toIso8601String(),
        "date_modified": dateModified.toIso8601String(),
        "date_modified_gmt": dateModifiedGmt.toIso8601String(),
        "src": src,
        "name": name,
        "alt": alt,
        "position": position,
      };
}
