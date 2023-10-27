import 'dart:convert';
import 'dart:io';

import 'package:candlesticks/candlesticks.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

class Repository{
  var _yaml = loadYaml(File('config/routes.yaml').readAsStringSync());

  WebSocketChannel establishConnection(List<String> symbols) {
    final wsUrl = Uri.parse(_yaml['wsUrl']);
    var channel = WebSocketChannel.connect(wsUrl);

    for (var symbol in symbols) {
      channel.sink.add(
        jsonEncode(
          {"type":"subscribe", "symbol": symbol,},
        ),
      );
    }
    return channel;
  }

  Future<List<Candle>> fetchHistory(String symbols, String resolution, int? from, int? to) {
    final stringUrl = _yaml['baseUrl'] + '/stock/candle?symbol=$symbols&resolution=$resolution' +
        (from != null ? '&from=$from' : '') +
        (to != null ? '&to=$to' : '');
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
          volume: volume[i].toDouble()
        ));
      }
      return candles;
    });
    return candleList;
  }
}