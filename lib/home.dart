import 'package:flutter/material.dart';
import './recording.dart';

class HomePageDart extends StatelessWidget {
  const HomePageDart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF757575),
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
              'ホーム',
              style: TextStyle(color: Colors.black),
            )),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Column(
            children: [
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
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: const Text('ベッドに入った時間'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 180),
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
