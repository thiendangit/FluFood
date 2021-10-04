import 'package:flufood/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final data;

  const ProductCard({Key? key, this.data}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    Product item = this.widget.data;
    var realPrice = item.salePrice != ""
        ? item.salePrice
        : item.regularPrice != ""
            ? item.regularPrice
            : item.price != ""
                ? item.price
                : '0';
    var salesPrice = item.regularPrice != ""
        ? item.regularPrice
        : item.price != ""
            ? item.price
            : '0';
    // var salesPriceFormat = salesPrice.runtimeType == int
    //     ? int.parse(salesPrice.toString() != '' ? salesPrice.toString() : '0')
    //     : double.parse(
    //         salesPrice.toString() != '' ? salesPrice.toString() : '0');
    var salesPriceDisplay = salesPrice.toString() != realPrice.toString()
        ? salesPrice.toString()
        : '0';

    var image = (item.images!.length > 0 && item.images![0].src != null)
        ? item.images![0].src
        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Picture_icon_BLACK.svg/1200px-Picture_icon_BLACK.svg.png';

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(image,
                                height: 120, width: 120, fit: BoxFit.fill),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 4, left: 4),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                                visible: salesPriceDisplay != '0',
                                child: Text(
                                  '\$$salesPriceDisplay',
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: Text(
                                '\$$realPrice',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                      visible: item.calculateDiscount() != null &&
                          item.calculateDiscount() > 0,
                      child: Positioned(
                        top: 5,
                        left: 5,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              '${item.calculateDiscount()}% OFF',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )),
                ],
              )),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0XFFFFFFFF),
              boxShadow: [
                BoxShadow(
                    color: Color(0xfff8f8f8), spreadRadius: 10, blurRadius: 15)
              ]),
        ),
      ],
    );
  }
}
