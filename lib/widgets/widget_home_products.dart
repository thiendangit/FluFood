import 'package:flufood/models/product.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetHomeProducts extends StatefulWidget {
  final String labelName;
  final String tagId;

  const WidgetHomeProducts(
      {Key? key, required this.labelName, required this.tagId})
      : super(key: key);

  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {
  late ApiService apiService;

  @override
  void initState() {
    // TODO: implement initState
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  this.widget.labelName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              )
            ],
          ),
          _productList()
        ],
      ),
    );
  }

  Widget _productList() {
    return FutureBuilder(
        future: apiService.getProducts(tagName: this.widget.tagId),
        builder: (_, AsyncSnapshot<List<Product>> res) {
          if (res.hasData && res.data != null) {
            return _buildProductList(res.data);
          }
          return Center(
              child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 30,
            width: 30,
            child: CircularProgressIndicator(strokeWidth: 2),
          ));
        });
  }

  Widget _buildProductList(List<Product>? products) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: products?.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, idx) {
            Product item = products![idx];
            var realPrice = item.salePrice != ""
                ? item.salePrice
                : item.regularPrice != ""
                    ? item.regularPrice
                    : item.price;
            var salesPrice =
                item.regularPrice != "" ? item.regularPrice : item.price;
            var salesPriceDisplay = salesPrice != realPrice
                ? salesPrice
                : int.parse((salesPrice ?? '0')) - 2;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  child: item.images![0].src != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(item.images![0].src,
                              height: 120, width: 120, fit: BoxFit.fill),
                        )
                      : Icon(Icons.ac_unit),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 5),
                            blurRadius: 15)
                      ]),
                ),
                Container(
                    width: 130,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 4, left: 4),
                  width: 130,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      salesPriceDisplay != ''
                          ? Text(
                              '\$$salesPriceDisplay',
                              style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w400),
                            )
                          : SizedBox(),
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
            );
          }),
    );
  }
}
