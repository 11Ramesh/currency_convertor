class CurrencyService {
  static Map<String, dynamic>? _currencyData;

  static void setCurrencyData(Map<String, dynamic> data) {
    _currencyData = data;
  }

  static Map<String, dynamic>? getCurrencyData() {
    return _currencyData;
  }
}
