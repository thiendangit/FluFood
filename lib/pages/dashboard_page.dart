import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flufood/provider/cart_provider.dart';
import 'package:flufood/services/api_contanst.dart';
import 'package:flufood/widgets/widget_home_categories.dart';
import 'package:flufood/widgets/widget_home_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

final List<String> imgList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTm9YJ3iuDQzK8G7ieZtB5PyIL138Xin0XqW1xGagLjLRDxPTsVn9p2TiQMjpPV5ChXP7Q&usqp=CAU'
      'https://img.freepik.com/free-vector/modern-black-friday-sale-banner-template-with-3d-background-red-splash_1361-1877.jpg?size=626&ext=jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7Ql0qNZ1Xkj9Pn34zW8PzKmI8EP5AruriaBgI9ohzRN6xiiLZjX3Z9UYS1aTuWy54hgs&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQoWhLhSFlv20jarcdwWxsnJt1DSQgyVUG0oPCz62ow-BviifGBM53TtMT1xqXR6nJKC4&usqp=CAU',
  'https://previews.123rf.com/images/elenabsl/elenabsl1509/elenabsl150900091/46200067-fashion-clothing-store-banner-with-shop-interior-clothing-on-hangers-and-shelves-fitting-rooms-and-c.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQo4KqcfO156yczF_Pe7Uew1cPMaabKZTKRGQ&usqp=CAU'
];

class _DashboardPageState extends State<DashboardPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
      body: Container(
          child: ListView(
        children: [
          Stack(children: <Widget>[
            Container(
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              height: 175,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
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
                                .withOpacity(_current == entry.key ? 1 : 0.3)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ]),
          WidgetCategories(),
          WidgetHomeProducts(
              labelName: "Best selling products",
              tagId: ApiConfig.bestSellingTagID),
          WidgetHomeProducts(
              labelName: "Recommend for you", tagId: ApiConfig.recommendTagID),
        ],
      )),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'FluFood',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Center(
          child: Badge(
            position: BadgePosition.topEnd(top: -15),
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, _) {
                return Text(
                  value.counter.toString(),
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
            animationDuration: Duration(microseconds: 300),
            badgeColor: Colors.blue,
            child: Icon(Icons.shopping_cart_sharp, color: Colors.white),
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  )),
            ),
          ))
      .toList();
}
