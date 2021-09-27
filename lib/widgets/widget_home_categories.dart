import 'dart:ui';
import 'package:flufood/models/category.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetCategories extends StatefulWidget {
  const WidgetCategories({Key? key}) : super(key: key);

  @override
  _WidgetCategoriesState createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
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
                  'All categories',
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
          _categoriesList()
        ],
      ),
    );
  }

  Widget _categoriesList() {
    return FutureBuilder(
        future: apiService.getCategories(),
        builder: (_, AsyncSnapshot<List<Category>> res) {
          if (res.hasData && res.data != null) {
            return _buildCategoryList(res.data);
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

  Widget _buildCategoryList(List<Category>? categories) {
    return Container(
      height: 150,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories?.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, idx) {
            Category item = categories![idx];
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: item.image?.src != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(item.image!.src!,
                              height: 80, width: 80, fit: BoxFit.cover),
                        )
                      : Icon(Icons.ac_unit),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 5),
                            blurRadius: 15)
                      ]),
                ),
                Row(
                  children: [
                    Text(item.name),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 14,
                    )
                  ],
                )
              ],
            );
          }),
    );
  }
}
