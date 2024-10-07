import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:flutter/material.dart';

class ListTiles extends StatelessWidget {
  final String picture;
  final String text;
  final String currencyCode;
  final void Function()? onPressed;
  final void Function()? onTapTile;
  ListTiles(
      {required this.onTapTile,
      required this.picture,
      required this.text,
      required this.currencyCode,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tilefill,
        border: Border.all(), // Border color and width
        borderRadius:
            BorderRadius.circular(15.0), // Optional: for rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: Colors.black,
        onTap: onTapTile,
        contentPadding: EdgeInsets.only(left: 16.0),
        leading: Textshow(text: text, fontSize: 20),
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
