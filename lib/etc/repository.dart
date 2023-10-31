import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import 'package:stock_dashboard_flutter/config/routes.dart';

class Repository {
  Repository._privateConstructor();
  static final Repository _singleton = Repository._privateConstructor();
  factory Repository() {
    return _singleton;
  }

  WebSocketChannel establishConnection(List<String> symbols) {
    final wsUrl = Uri.parse(properties['wsUrl'] + '?token=' + properties['apiKey']);
    var channel = WebSocketChannel.connect(wsUrl);

    for (var symbol in symbols) {
      channel.sink.add(
        jsonEncode(
          {
            "type": "subscribe",
            "symbol": symbol,
          },
        ),
      );
    }
    return channel;
  }

  Future<List<Candle>> fetchHistory(String symbols, String resolution, int? from, int? to) {
    final stringUrl = properties['baseUrl'] +
        '/stock/candle?symbol=$symbols&resolution=$resolution' +
        (from != null ? '&from=$from' : '') +
        (to != null ? '&to=$to' : '') +
        '&token=' +
        properties['apiKey'];
    final url = Uri.parse(stringUrl);
    final res = http.get(url);
    final candleList = res.then((value) {
      Map<String, dynamic> decodedJson = jsonDecode(value.body);
      if(decodedJson['s'] != 'ok'){
        throw Exception('No data found');
      }
      List<Candle> candles = [];
      final close = decodedJson['c'] as List<double>;
      final open = decodedJson['o'] as List<double>;
      final high = decodedJson['h'] as List<double>;
      final low = decodedJson['l'] as List<double>;
      final timestamp = decodedJson['t'] as List<int>;
      final volume = decodedJson['v'] as List<int>;
      for (var i = 0; i < timestamp.length; i++) {
        candles.add(Candle(
            date: DateTime.fromMillisecondsSinceEpoch(timestamp[i] * 1000),
            high: high[i],
            low: low[i],
            open: open[i],
            close: close[i],
            volume: volume[i].toDouble()));
      }
      return candles;
    });
    return candleList;
  }
}
