import 'dart:ffi';

import 'package:currency_convertor/bloc/getconvertor/getconvertor_bloc.dart';
import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/const/currencycode.dart';
import 'package:currency_convertor/const/flags.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/widget/button.dart';
import 'package:currency_convertor/widget/currency_input.dart';
import 'package:currency_convertor/widget/listtile.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:currency_convertor/widget/textformfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

List? flagData = FlagService.getCurrencyData();
Map<String, dynamic>? currencyData = CurrencyService.getCurrencyData();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  String InsertCurrencyCode = "USD";
  List<String> ConvertCurrencyCode = [];
  double InsertCurrency = 0;
  late String currencyimage = "https://flagcdn.com/w320/gu.png";
  late GetconvertorBloc getconvertorBloc;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    inilization();
  }

  Future<void> inilization() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        ConvertCurrencyCode =
            sharedPreferences.getStringList('ConvertCurrencyCodeList') ?? [];
        InsertCurrencyCode =
            sharedPreferences.getString('InsertCurrencyCode') ?? "USD";
        getconvertorBloc = BlocProvider.of<GetconvertorBloc>(context);
        getconvertorBloc.add(GetEvent(InsertCurrencyCode, ConvertCurrencyCode));

        currencyimage = sharedPreferences.getString('currencyimage') ??
            "https://flagcdn.com/w320/gu.png";

        print(currencyimage);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Textshow(
            text: "Advanced Exchanger",
            fontSize: 20,
            fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Textshow(
                text: 'Insert Amount',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            CurrencyInput(
              picture: currencyimage!,
              leading: CustomTextFormField(
                hintText: 'Enter Value',
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      InsertCurrency = 0;
                    } else {
                      try {
                        InsertCurrency = double.parse(value);
                      } catch (e) {
                        // Handle error (e.g., log it or set a default value)
                        InsertCurrency =
                            0; // Or any other default value you prefer
                        print('Invalid input: $value');
                      }
                    }
                  });
                },
              ),
              currencyCode: InsertCurrencyCode,
              onPressed: () {
                showBoxCurrency(context, "Insert", "");
              },
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Textshow(
                text: 'Convert Amount',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<GetconvertorBloc, GetconvertorState>(
                builder: (context, state) {
              if (state is GetState) {
                Map<String, dynamic> result = state.result;
                List flagResultData = state.flagResultData;

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: result.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTiles(
                      text:
                          '${(double.parse(result.values.toList()[index].toString()) * InsertCurrency).toStringAsFixed(2)}',
                      currencyCode: '${result.keys.toList()[index]}',
                      picture: flagResultData[index]!,
                      onPressed: () {
                        String changeItem = (result.keys.toList()[index]);

                        showBoxCurrency(context, "Change", changeItem);
                      },
                      onTapTile: () {
                        showDeleteConfirmationDialog(
                            context, result.keys.toList()[index]);
                      },
                    );
                  },
                );
              } else if (state is ErrorState) {
                return Textshow(
                  text: "No Data Found",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                );
              }
              return CircularProgressIndicator();
            }),
            Button(
              text: '+ Add Convertor',
              onPressed: () {
                showBoxCurrency(context, "Convert", "");
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> showBoxCurrency(
      BuildContext context, String text, String changeItem) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 57, 57, 57),
          title: Textshow(
              text: text + " Currency",
              fontSize: 20,
              fontWeight: FontWeight.bold),
          content: Container(
            width: ScreenUtil.screenWidth * 0.5,
            height: ScreenUtil.screenHeight * 0.5,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencyData!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Textshow(
                        text: currencyData!.keys.toList()[index],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.of(context).pop({
                        "currencyCode":
                            currencyData!.keys.toList()[index].toString(),
                      });
                    },
                  );
                }),
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        if (text == "Insert") {
          InsertCurrencyCode = result["currencyCode"]!;
          sharedPreferences.setString('InsertCurrencyCode', InsertCurrencyCode);
          for (var element in flagData!) {
            if (result["currencyCode"]! == element['curruncy'].toString()) {
              currencyimage = element['flag'].toString();
              sharedPreferences.setString('currencyimage', currencyimage);
            }
          }
          getconvertorBloc
              .add(GetEvent(InsertCurrencyCode, ConvertCurrencyCode));
        } else if (text == "Convert") {
          ConvertCurrencyCode.add(result["currencyCode"]!);
          sharedPreferences.setStringList(
              'ConvertCurrencyCodeList', ConvertCurrencyCode);
          getconvertorBloc
              .add(GetEvent(InsertCurrencyCode, ConvertCurrencyCode));
        } else if (text == "Change") {
          if (!ConvertCurrencyCode.contains(result["currencyCode"]!)) {
            int index = ConvertCurrencyCode.indexOf(changeItem);
            ConvertCurrencyCode[index] = result["currencyCode"]!;
            sharedPreferences.setStringList(
                'ConvertCurrencyCodeList', ConvertCurrencyCode);
            getconvertorBloc
                .add(GetEvent(InsertCurrencyCode, ConvertCurrencyCode));
          }
        }
      });
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, String currencyCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete ${currencyCode} item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  ConvertCurrencyCode.remove(currencyCode);
                  sharedPreferences.setStringList(
                      'ConvertCurrencyCodeList', ConvertCurrencyCode);
                  getconvertorBloc
                      .add(GetEvent(InsertCurrencyCode, ConvertCurrencyCode));
                });

                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
