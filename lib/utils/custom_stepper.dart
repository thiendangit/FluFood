import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  final int lowerLimit;
  final int upperLimit;
  final int stepValue;
  final double iconSize;
  late int value = 0;
  final ValueChanged<dynamic> onChanged;

  CustomStepper({
    Key? key,
    required this.lowerLimit,
    required this.upperLimit,
    required this.value,
    required this.iconSize,
    required this.stepValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.white, blurRadius: 15, spreadRadius: 10)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                widget.value = widget.value == widget.lowerLimit
                    ? widget.lowerLimit
                    : widget.value -= widget.stepValue;
                widget.onChanged(widget.value);
              },
              icon: Icon(Icons.remove)),
          Container(
            width: this.widget.iconSize,
            child: Text(
              '${widget.value}',
              style: TextStyle(
                fontSize: widget.iconSize * 0.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
              onPressed: () {
                widget.value = widget.value == widget.upperLimit
                    ? widget.upperLimit
                    : widget.value += widget.stepValue;
                widget.onChanged(widget.value);
              },
              icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
