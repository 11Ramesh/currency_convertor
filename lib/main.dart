import 'dart:convert';
import 'dart:io';

import 'package:currency_convertor/bloc/getconvertor/getconvertor_bloc.dart';
import 'package:currency_convertor/const/color.dart';
import 'package:currency_convertor/const/currencycode.dart';
import 'package:currency_convertor/const/flags.dart';
import 'package:currency_convertor/const/shakeEror.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/const/url.dart';
import 'package:currency_convertor/screen/connectionFaild.dart';
import 'package:currency_convertor/screen/home.dart';
import 'package:currency_convertor/screen/tokenExpired.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';

bool isconnection = true;

void main() async {
  // hand shake Error fix
  HttpOverrides.global = MyHttpOverrides();
  // load .env for get crediatial
  await dotenv.load(fileName: ".env");
  await WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
// run app in device preview
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => const MyApp(),
  // ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (context) => GetconvertorBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InternetCheck(),
      ),
    );
  }
}

class InternetCheck extends StatefulWidget {
  const InternetCheck({super.key});

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getFlag();
    _check();
  }

  Future<void> _check() async {
    await getCurrencyCode(context);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgcolor,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // get ocnnection have or not
    return isconnection ? const Home() : const Connectionfaild();
  }
}

//initially all corruncy code get
Future<void> getCurrencyCode(BuildContext context) async {
  try {
    final url = Uri.parse(allCurrencyUrl)
        .replace(queryParameters: {"api_key": dotenv.env['api_key']});

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      Map<String, dynamic> data = responseData['results'];
      //print(data.length);
      CurrencyService.setCurrencyData(data);
    } else {
      //when retorn another satatus move this page
      isconnection = false;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TokenExpied()));
    }
  } catch (e) {
    //when connection eroor  move this page
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please Check Your Internet Connection'),
      duration: Duration(seconds: 3),
    ));
    isconnection = false;
  }
}

// initially all flag data get
getFlag() async {
  List flag = [];
  try {
    final url = Uri.parse(flagUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      for (var element in responseData) {
        if (element['currencies'] != null && element['flags'] != null) {
          Map<String, dynamic> data = {
            "curruncy": element['currencies'].keys.toList()[0],
            "flag": element['flags']['png']
          };
          flag.add(data);
        }
        FlagService.setCurrencyData(flag);
      }
    } else {}
  } catch (e) {
    print(e);
  }
}
