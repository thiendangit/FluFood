import 'package:flufood/models/product.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetRelatedProduct extends StatefulWidget {
  List<int> productIds;
  String labelName;

  WidgetRelatedProduct(
      {Key? key, required this.labelName, required this.productIds})
      : super(key: key);

  @override
  _RelatedProductState createState() => _RelatedProductState();
}

class _RelatedProductState extends State<WidgetRelatedProduct> {
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
        future: apiService.getProducts(productIDs: this.widget.productIds),
        builder: (_, AsyncSnapshot<List<Product>> res) {
          if (res.hasData && res.data != null) {
            return _buildProductList(res.data);
          }
          return Container(
            height: 150,
            child: Center(
                child: Container(
              margin: EdgeInsets.only(top: 0),
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            )),
          );
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

            var image = (item.images!.length > 0 && item.images![0].src != null)
                ? item.images![0].src
                : 'https://langmaster.edu.vn/public/files/no-photo.png';

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(image,
                        height: 120, width: 120, fit: BoxFit.fill),
                  ),
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
                      item.calculatePrice().salesPrice != '0'
                          ? Text(
                              '\$' +
                                  (item.calculatePrice().salesPrice.toString()),
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
                          '\$' + item.calculatePrice().price.toString(),
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
