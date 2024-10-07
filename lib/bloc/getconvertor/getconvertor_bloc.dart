import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:currency_convertor/const/flags.dart';
import 'package:currency_convertor/const/url.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'getconvertor_event.dart';
part 'getconvertor_state.dart';

List? flagData = FlagService.getCurrencyData();

class GetconvertorBloc extends Bloc<GetconvertorEvent, GetconvertorState> {
  GetconvertorBloc() : super(GetconvertorInitial()) {
    on<GetconvertorEvent>((event, emit) async {
      if (event is GetEvent) {
        String InsertCurrencyCode = event.InsertCurrencyCode;
        List ConvertCurrencyCode = event.ConvertCurrencyCode;
        List flagResultData = [];

        try {
          final queryParams = {
            "api_key": dotenv.env['api_key']!,
            "from": InsertCurrencyCode,
            "to": ConvertCurrencyCode.join(
                ','), // Join the list into a comma-separated string
          };

          final url =
              Uri.parse(convertorsUrl).replace(queryParameters: queryParams);

          final response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
          );
          print(response.statusCode);
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);

            Map<String, dynamic> data = responseData['results'];

            if (response.statusCode == 200 && flagData != null) {
              final responseData = json.decode(response.body);

              Map<String, dynamic> data = responseData['results'];

              for (var element in data.keys.toList()) {
                for (var element1 in flagData!) {
                  if (element.toString() == element1['curruncy'].toString()) {
                    flagResultData.add(element1['flag']);
                    break;
                  }
                }
              }
            }

            emit(GetState(result: data, flagResultData: flagResultData));
          } else {
            emit(ErrorState());
          }
        } catch (e) {}

        //emit(GetState());
      }
    });
  }
}
