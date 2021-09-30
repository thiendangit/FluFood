import 'package:flufood/models/product.dart';
import 'package:flufood/pages/base_page.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flufood/widgets/widget_product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends BasePage {
  final categoryId;

  const ProductPage({Key? key, this.categoryId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class SortBy {
  late String value;
  late String text;
  late String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

class _ProductPageState extends BasePageState<ProductPage> {
  late ApiService apiService;

  final _sortOption = [
    SortBy('popularity', 'Popularity', 'asc'),
    SortBy('modified', 'Latest', 'asc'),
    SortBy('price', 'Price: High to Low', 'desc'),
    SortBy('price', 'Price: Low to High', 'asc'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget pageUI() {
    // TODO: implement pageUI
    return Container(
      child: _categoriesList(),
    );
  }

  Widget _categoriesList() {
    return FutureBuilder(
        future: apiService.getProducts(),
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
    return Column(
      children: [
        _productFilters(),
        Flexible(
            child: GridView.count(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: products!.map((Product product) {
            return ProductCard(data: product);
          }).toList(),
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
        ))
      ],
    );
  }

  Widget _productFilters() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
              child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      fillColor: Color(0xffe6e6ec),
                      filled: true))),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
                color: Color(0xffe6e6ec),
                borderRadius: BorderRadius.circular(9)),
            child: PopupMenuButton(
              onSelected: (sortBy) {},
              itemBuilder: (BuildContext context) {
                return _sortOption.map((e) {
                  return PopupMenuItem(
                      value: e,
                      child: Container(
                        child: Text(e.text),
                      ));
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          )
        ],
      ),
    );
  }
}
