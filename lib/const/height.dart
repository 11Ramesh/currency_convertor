import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  double height;
  Height({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
