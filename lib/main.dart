import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_dashboard_flutter/stock_item.dart';
import 'package:stock_dashboard_flutter/stock_market_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var stockEntries = <StockItem>[];

  void addStockEntry(StockItem entry) {
    stockEntries.add(entry);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = Placeholder();
    switch (selectedIndex) {
      case 0:
        page = StockMarketPage();
        break;
      case 1:
        break;
      default:
        throw Exception('Invalid index: $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: selectedIndex == 0 ? buildAppBar() : null,
        bottomNavigationBar: buildBottomNavigationBar(),
        body:
          page,
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
        ),
        title: Text('Stock Market'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        );
  }
}
