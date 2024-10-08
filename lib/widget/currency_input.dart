import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/const/width.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:flutter/material.dart';

class CurrencyInput extends StatelessWidget {
  final String currencyCode;
  final Widget leading;
  final String picture;
  final void Function()? onPressed;

  CurrencyInput({
    required this.picture,
    required this.currencyCode,
    required this.leading,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tilefill, // Background color for the container
        border: Border.all(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: Colors.black, // Changed the fill color for the ListTile
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0), // Adjusted padding
        leading: leading,
        trailing: SizedBox(
          width: 200, // Control the width to avoid overflow
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: ScreenUtil.screenWidth * 0.1,
                height: ScreenUtil.screenWidth * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    picture,
                    fit: BoxFit.cover,
                    width: ScreenUtil.screenWidth * 0.1,
                    height: ScreenUtil.screenWidth * 0.1,
                  ),
                ),
              ),
              Width(width: 10),
              Textshow(text: currencyCode, fontSize: 20),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
