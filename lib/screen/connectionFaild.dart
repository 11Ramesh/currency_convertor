import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:flutter/material.dart';

class Connectionfaild extends StatefulWidget {
  const Connectionfaild({super.key});

  @override
  State<Connectionfaild> createState() => _ConnectionfaildState();
}

class _ConnectionfaildState extends State<Connectionfaild> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Textshow(
          text: "No Internet Connection",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
