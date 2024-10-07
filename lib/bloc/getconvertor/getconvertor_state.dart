part of 'getconvertor_bloc.dart';

@immutable
abstract class GetconvertorState {}

final class GetconvertorInitial extends GetconvertorState {}

class GetState extends GetconvertorState {
  Map<String, dynamic> result;
  List flagResultData;
  GetState({required this.result, required this.flagResultData});
}

class ErrorState extends GetconvertorState {
  ErrorState();
}
