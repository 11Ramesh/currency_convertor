import 'package:flutter/material.dart';

class Textshow extends StatelessWidget {
  String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  Textshow(
      {required this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.white,
      ),
    );
  }
}
