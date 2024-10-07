import 'dart:convert';
import 'dart:io';

import 'package:currency_convertor/bloc/getconvertor/getconvertor_bloc.dart';
import 'package:currency_convertor/const/currencycode.dart';
import 'package:currency_convertor/const/flags.dart';
import 'package:currency_convertor/const/size.dart';
import 'package:currency_convertor/const/url.dart';
import 'package:currency_convertor/screen/connectionFaild.dart';
import 'package:currency_convertor/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

bool isconnection = true;

// hand shake Error fix
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");

  await WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (context) => GetconvertorBloc(),
      child: MaterialApp(
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isconnection ? const Home() : const Connectionfaild();
  }
}

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
      isconnection = false;
    }
  } catch (e) {
    isconnection = false;
  }
}

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
