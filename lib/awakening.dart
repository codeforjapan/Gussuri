import 'package:flutter/material.dart';
import 'package:gussuri/awakening_time.dart';
import 'package:gussuri/finish.dart';
import 'package:gussuri/sleepy.dart';

import 'home.dart';

class Awaking extends StatelessWidget {
  const Awaking({required this.title, required this.text});

  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black),
            )),
        actions: [
          ElevatedButton(
            child: const Text('ホーム'),
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageDart()));
            },
          )
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('0回'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Finish()));
                    },
                  )),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text('1回'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AwakingTime(
                                    title: '中途覚醒', text: '再び眠りに入るまでにかかった時間')));
                      })),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text('2回'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AwakingTime(
                                    title: '中途覚醒', text: '再び眠りに入るまでにかかった時間')));
                      })),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text('3回以上'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AwakingTime(
                                    title: '中途覚醒', text: '再び眠りに入るまでにかかった時間')));
                      })),
            ],
          )),
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: ElevatedButton(
                      child: const Text('前へ'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 60),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Sleepy(
                                    title: '寝付くまでにかかった時間',
                                    text: '寝付くまでにかかった時間')));
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 28.0),
                  child: ElevatedButton(
                    child: const Text('次へ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(70, 60),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Finish()));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
