import 'package:flutter/material.dart';
import 'package:gussuri/about_me.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/privacy_policy.dart';
import 'package:gussuri/terms_of_service%20.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final List<Map<String, dynamic>> listItems = [
    {"title": 'このアプリの使い方', "link": const AboutMe()},
    {"title": 'プライバシーポリシー', "link": const PrivacyPolicy()},
    {"title": '利用規約', "link": const TermsOfService()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const TitleBox(text: 'ヘルプ'),
        ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFC4C4C4)),
                    ),
                  ),
                  child: ListTile(
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title: Text(listItems[index]['title']),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => listItems[index]['link']));
                    },
                  ));
            })
      ],
    ));
  }
}
