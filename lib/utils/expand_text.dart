import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandText extends StatefulWidget {
  String labelHeader;
  String desc;
  String shortDesc;

  ExpandText(
      {Key? key, this.labelHeader = '', this.desc = '', this.shortDesc = ''})
      : super(key: key);

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool descTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.widget.labelHeader,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Html(
            data: descTextShowFlag ? this.widget.desc : this.widget.shortDesc,
            style: {
              "div": Style(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  fontSize: FontSize.medium)
            },
          ),
          Align(
            child: GestureDetector(
              child: Text(
                descTextShowFlag ? "Show less" : "Show more",
                style: TextStyle(color: Colors.blueAccent),
              ),
              onTap: () {
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
