import 'package:flufood/models/product.dart';
import 'package:flufood/widgets/widget_product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'base_page.dart';

class ProductDetailPage extends BasePage {
  ProductDetailPage({Key? key, required this.product}) : super(key: key);
  Product product;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends BasePageState<ProductDetailPage> {
  @override
  Widget pageUI() {
    return Container(
      child: ProductDetailWidget(product: this.widget.product),
    );
  }
}
