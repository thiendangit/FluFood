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
    var salesPriceDisplay = salesPrice.toString() != realPrice.toString()
        ? salesPrice.toString()
        : int.parse(salesPrice.toString() != '' ? salesPrice.toString() : '0') >
                0
            ? int.parse(salesPrice.toString()) - 2
            : '0';
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: item.images![0].src != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(item.images![0].src,
                                    height: 120, width: 120, fit: BoxFit.fill),
                              )
                            : Icon(Icons.ac_unit),
                      ),
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
                            maxLines: 2,
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
