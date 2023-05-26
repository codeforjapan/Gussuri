import 'package:flutter/material.dart';
import 'package:gussuri/component/title_box.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: const [
            TitleBox(text: 'このアプリの使い方'),
          ],
        ));
  }
}
