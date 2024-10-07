part of 'getconvertor_bloc.dart';

@immutable
abstract class GetconvertorEvent {}

class GetEvent extends GetconvertorEvent {
  String InsertCurrencyCode;
  List ConvertCurrencyCode;
  GetEvent(this.InsertCurrencyCode, this.ConvertCurrencyCode);
}
