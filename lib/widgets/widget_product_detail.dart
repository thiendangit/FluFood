import 'package:carousel_slider/carousel_slider.dart';
import 'package:flufood/models/cart.dart';
import 'package:flufood/models/product.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flufood/utils/custom_stepper.dart';
import 'package:flufood/utils/db_helper.dart';
import 'package:flufood/utils/expand_text.dart';
import 'package:flufood/widgets/widget_related_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductDetailWidget extends StatefulWidget {
  ProductDetailWidget({Key? key, this.product}) : super(key: key);
  Product? product;

  @override
  _ProductDetailWidgetState createState() =>
      _ProductDetailWidgetState(product: product);
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  Product? product;

  _ProductDetailWidgetState({this.product});

  final CarouselController _controller = CarouselController();
  int _current = 0;
  int qty = 0;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (product != null) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: productImages(
                          product!.images as List<ImageType>?, context)),
                  Visibility(
                      visible: product!.calculateDiscount() > 0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.green),
                          child: Text(
                            '${product!.calculateDiscount()}% OFF',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  SizedBox(height: 5),
                  Text(
                    product!.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(product?.attributes != null &&
                              product!.attributes.length > 0
                          ? (product!.attributes[0].options
                                  .join('-')
                                  .toString() +
                              ' ' +
                              product!.attributes[0].name)
                          : ''),
                      Text(
                        '\$${product!.calculatePrice().price}',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomStepper(
                          lowerLimit: 0,
                          upperLimit: 20,
                          value: this.qty,
                          iconSize: 22.0,
                          stepValue: 1,
                          onChanged: (value) {
                            setState(() {
                              this.qty = value;
                            });
                          }),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent, // foreground
                              padding: EdgeInsets.all(15),
                              shape: StadiumBorder()),
                          onPressed: () {
                            if (qty > 0) {
                              Cart cart = Cart(
                                  id: product!.id,
                                  name: product?.name ?? 'Example',
                                  sku: '2',
                                  price: product?.price ?? "0.0",
                                  regular_price: product?.regularPrice ?? "0.0",
                                  sale_price: product?.salePrice ?? "0.0",
                                  images: ((product!.images!.length > 0 &&
                                              product!.images![0].src != null)
                                          ? product!.images![0].src
                                          : 'https://langmaster.edu.vn/public/files/no-photo.png')
                                      .toString(),
                                  quantity: qty);
                              DBHelper.instance.insert(cart).then((value) {
                                cartProvider.addCounter();
                                if (product?.calculatePrice().price != '0') {
                                  cartProvider.addTotalPrice(double.parse(
                                          product!.calculatePrice().price
                                              as String) *
                                      qty);
                                }
                                print(
                                    'Product is added successfully! ${value.toString()}');
                              }).catchError((err) {
                                print('Product is added fail!');
                                print(err?.toString());
                                print(cart.toJson());
                              });
                            } else {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Cart notification'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Can\'t add to cart with quantity is 0 !.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ExpandText(
                    labelHeader: 'Product Details',
                    shortDesc: product!.shortDescription.substring(0, 150),
                    desc: product!.description,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  WidgetRelatedProduct(
                    productIds: this.widget.product!.relatedIds,
                    labelName: 'Related Products',
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget productImages(List<ImageType>? images, BuildContext context) {
    const double? ImageHeight = 350;

    if (images != null && images.length > 0) {
      return Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: ImageHeight,
          child: CarouselSlider(
            items: images
                .map((item) => Container(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(item.src,
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width,
                                    height: ImageHeight),
                              ],
                            )),
                      ),
                    ))
                .toList(),
            carouselController: _controller,
            options: CarouselOptions(
                // autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        images.length > 1
            ? Container(
                alignment: Alignment.bottomLeft,
                height: ImageHeight * 0.85,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.redAccent
                                      : Colors.white)
                                  .withOpacity(
                                      _current == entry.key ? 1 : 0.3)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            : SizedBox(),
      ]);
    }
    return SizedBox();
  }
}
