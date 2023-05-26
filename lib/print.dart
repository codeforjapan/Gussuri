import 'package:flutter/material.dart';
import 'package:gussuri/component/title_box.dart';

class Print extends StatefulWidget {
  const Print({Key? key}) : super(key: key);

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          TitleBox(text: '睡眠記録の印刷'),
        ],
      )
    );
  }
}
