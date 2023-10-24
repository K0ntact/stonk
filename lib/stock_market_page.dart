import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_dashboard_flutter/stock_item.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'main.dart';

class StockMarketPage extends StatefulWidget {
  @override
  State<StockMarketPage> createState() => _StockMarketPageState();
}

class _StockMarketPageState extends State<StockMarketPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var entries = List<StockItem>.from(appState.stockEntries);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView(
          children: [
            for (var entry in entries)
              Row(
                children: [
                  Column(
                      children: [
                        Text(entry.symbol),
                        Text(entry.companyName),
                      ]
                  ),
                  buildAreaChart(entry),
                  Column(
                    children: [
                      Text(entry.price.toString()),
                      Text(entry.percentage.toString()),
                    ],
                  )
                ],
              )
          ],
        ),
      ],
    );
  }

  SfCartesianChart buildAreaChart(StockItem entry) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        series: <ChartSeries>[
          AreaSeries<Candle, DateTime>(
            dataSource: entry.stockData,
            xValueMapper: (Candle candle, _) => candle.date,
            yValueMapper: (Candle candle, _) => candle.close,
            // Disable the tooltip visibility.
            enableTooltip: false,
            // Disable the legend item.
            legendItemText: null,
          )
        ]
    );
  }
}