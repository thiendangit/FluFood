import 'dart:async';

import 'package:flufood/models/product.dart';
import 'package:flufood/pages/base_page.dart';
import 'package:flufood/provider/product_provider.dart';
import 'package:flufood/widgets/widget_product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends BasePage {
  final categoryId;

  const ProductPage({Key? key, this.categoryId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  final _sortOption = [
    SortBy('popularity', 'Popularity', 'asc'),
    SortBy('date', 'Latest', 'asc'),
    SortBy('price', 'Price: High to Low', 'desc'),
    SortBy('price', 'Price: Low to High', 'asc'),
  ];
  int _page = 1;
  ScrollController _scrollController = new ScrollController();
  Timer? _debounce;
  final _searchQuery = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStream();
    if (productList.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
      productList.setLoadingState(LoadMoreStatus.INITIAL);
    }
    productList.fetchProducts(_page);
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          productList.setLoadingState(LoadMoreStatus.LOADING);
          productList.fetchProducts(++_page);
        }
      });
    _searchQuery.addListener(_onSearchChange);
    super.initState();
  }

  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = new Timer(const Duration(microseconds: 500), () {
      productsList.resetStream();
      productsList.setLoadingState(LoadMoreStatus.INITIAL);
      productsList.fetchProducts(_page, strSearch: _searchQuery.text);
    });
  }

  @override
  Widget pageUI() {
    // TODO: implement pageUI
    return Container(
      child: _categoriesList(),
    );
  }

  Widget _categoriesList() {
    return Consumer<ProductProvider>(builder: (context, productModel, child) {
      if (productModel.allProducts != null &&
          productModel.allProducts.length > 0 &&
          productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildProductList(productModel.allProducts,
            productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
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

  Widget _buildProductList(List<Product>? products, isLoadMore) {
    return Column(
      children: [
        _productFilters(),
        Flexible(
            child: GridView.count(
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          children: products!.map((Product product) {
            if (product != null) {
              return ProductCard(data: product);
            } else {
              return SizedBox();
            }
          }).toList(),
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
        )),
        Visibility(
            visible: isLoadMore,
            child: Container(
              padding: EdgeInsets.all(5),
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(),
            )),
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
                  controller: _searchQuery,
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
              onSelected: (sortBy) {
                var productList =
                    Provider.of<ProductProvider>(context, listen: false);
                productList.resetStream();
                productList.setSortOrder(sortBy as SortBy);
                productList.fetchProducts(_page);
              },
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
