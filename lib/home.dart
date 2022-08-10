import 'package:flutter/material.dart';
import 'package:gussuri/recording.dart';
import './questionnaire.dart';

class HomePageDart extends StatelessWidget {
  const HomePageDart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF757575),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        centerTitle: false,
        title: const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
              'ホーム',
              style: TextStyle(color: Colors.black),
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    child: const Text('昨日の睡眠'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(315, 100),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      // todo Firebaseにデータ送信
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Questionnaire()));
                    },
                  )),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFBDBDBD)),
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
                width: double.infinity,
                height: 150,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 5),
                        child: const Text('入眠アドバイス',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    const Text(
                        '睡眠に関する小ネタが10個くらいがランダムに表示される。ああああああああああああああああああああああああああああああああああああああ')
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: ElevatedButton(
                    child: const Text('布団に入ります'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 150),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      // todo Firebaseにデータ送信
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Recording()));
                    },
                  )),
            ],
          )),
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Center(
              child: ElevatedButton(
                child: const Text('睡眠記録シート'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 60),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
