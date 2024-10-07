class FlagService {
  static List ? _flagData;

  static void setCurrencyData(List data) {
    _flagData = data;
  }

  static List ? getCurrencyData() {
    return _flagData;
  }
}
