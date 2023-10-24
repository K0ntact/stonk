import 'package:candlesticks/candlesticks.dart';

class StockItem {
  String symbol;
  String companyName;
  String description;
  double price;
  double percentage;
  double closePrice;
  List<Candle> stockData;

  StockItem({
    required this.symbol,
    required this.companyName,
    required this.description,
    required this.price,
    required this.percentage,
    required this.closePrice,
    required this.stockData,});
}