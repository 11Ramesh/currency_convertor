import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:flutter/material.dart';

class TokenExpied extends StatelessWidget {
  const TokenExpied({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Textshow(
          text: "Token Has Expired",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
