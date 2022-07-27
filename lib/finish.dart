import 'package:flutter/material.dart';
import 'package:gussuri/home.dart';

class Finish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  '記録しました',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                      child: const Text('睡眠記録シート'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {})),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text('ホームへ戻る'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageDart()));
                    },
                  )),
            ],
          )),
        ],
      ),
    );
  }
}
