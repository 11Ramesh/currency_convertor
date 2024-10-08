import 'dart:ffi';

import 'package:currency_convertor/bloc/getconvertor/getconvertor_bloc.dart';
import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/const/currencycode.dart';
import 'package:currency_convertor/const/flags.dart';
import 'package:currency_convertor/const/height.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/const/width.dart';
import 'package:currency_convertor/widget/button.dart';
import 'package:currency_convertor/widget/currency_input.dart';
import 'package:currency_convertor/widget/listtile.dart';
import 'package:currency_convertor/widget/textShow.dart';
import 'package:currency_convertor/widget/textformfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// this home page all component add in this page.widgets are in widget folder
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

  void dispose() {
    _controller.dispose();
    super.dispose();
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
    FocusNode searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
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
      body: Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil.screenWidth * 0.02,
            right: ScreenUtil.screenWidth * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Height(height: ScreenUtil.screenHeight * 0.05),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Textshow(
                  text: 'Insert Amount :',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CurrencyInput(
                picture: currencyimage!,
                leading: CustomTextFormField(
                  prefixIcon: false,
                  filled: false,
                  width: ScreenUtil.screenWidth * 0.3,
                  hintText: 'Enter Amount',
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
              Height(height: ScreenUtil.screenHeight * 0.05),
              BlocBuilder<GetconvertorBloc, GetconvertorState>(
                  builder: (context, state) {
                if (state is GetState) {
                  Map<String, dynamic> result = state.result;
                  List flagResultData = state.flagResultData;

                  return Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Textshow(
                          text: 'Convert Amount :',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: result.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTiles(
                            text:
                                '${(double.parse(result.values.toList()[index].toString()) * InsertCurrency).toStringAsFixed(2)}',
                            currencyCode: '${result.keys.toList()[index]}',
                            picture: index < flagResultData.length
                                ? flagResultData[index] ??
                                    "https://flagcdn.com/w320/gu.png"
                                : "https://flagcdn.com/w320/gu.png",
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
                      ),
                    ],
                  );
                } else if (state is ErrorState) {
                  return Column(
                    children: [
                      Textshow(
                        text: "No Found Convertor",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      Height(height: ScreenUtil.screenHeight * 0.02),
                    ],
                  );
                }
                return CircularProgressIndicator();
              }),
              Height(height: ScreenUtil.screenHeight * 0.02),
              Button(
                text: '+ Add Convertor',
                onPressed: () {
                  showBoxCurrency(context, "Convert", "");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showBoxCurrency(
      BuildContext context, String text, String changeItem) async {
    FocusNode searchFocusNode = FocusNode();
    final TextEditingController _controller1 = TextEditingController();
    List<MapEntry<String, String>> filteredEntries = currencyData!.entries
        .map((entry) => MapEntry(entry.key, entry.value.toString()))
        .toList();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            searchFocusNode.requestFocus();
          });
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 57, 57, 57),
            title: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Textshow(
                    text: text + " Currency :",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Height(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextFormField(
                    prefixIcon: true,
                    filled: true,
                    controller: _controller1,
                    keyboardType: TextInputType.text,
                    width: ScreenUtil.screenWidth * 0.8,
                    hintText: 'Search Currency',
                    onChanged: (value) {
                      setState(() {
                        final input = value.toUpperCase();
                        // Filter the currency data based on input
                        if (input.isNotEmpty) {
                          filteredEntries = currencyData!.entries
                              .where((entry) => entry.key.startsWith(input))
                              .map((entry) =>
                                  MapEntry(entry.key, entry.value.toString()))
                              .toList();
                        } else {
                          // Show all entries when the input is empty
                          filteredEntries = currencyData!.entries
                              .map((entry) =>
                                  MapEntry(entry.key, entry.value.toString()))
                              .toList();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            content: Container(
              width: ScreenUtil.screenWidth * 0.5,
              height: ScreenUtil.screenHeight * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Textshow(
                      text: filteredEntries[index].key,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: () {
                      // Pass back the selected currency code
                      Navigator.of(context).pop({
                        "currencyCode": filteredEntries[index].key,
                      });
                    },
                  );
                },
              ),
            ),
          );
        });
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
