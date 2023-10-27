import 'package:candlesticks/candlesticks.dart';

class StockData {
  String symbol;
  String companyName;
  String description;
  double price;
  double percentage;
  double closePrice;
  List<Candle> stockData;

  StockData({
    required this.symbol,
    this.companyName = "",
    this.description = "",
    this.price = 0,
    this.percentage = 0,
    this.closePrice = 0,
    this.stockData = const [],});

  void addCandle(Candle candle) {
    stockData.add(candle);
  }
}