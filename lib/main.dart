import 'package:flutter/material.dart';
import './home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pageList = [
    HomePageDart(),
    CustomPage(pannelColor: Colors.pink, title: 'Graph'),
    CustomPage(pannelColor: Colors.green, title: 'Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gussuri'),
      ),
      body: _pageList[_selectedIndex],
    );
  }
}

class CustomPage extends StatelessWidget {
  Color? pannelColor;
  String? title;
  CustomPage({@required this.pannelColor, this.title = 'aaa'});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: pannelColor,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Center(
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
