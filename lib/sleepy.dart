import 'package:flutter/material.dart';

class Sleepy extends StatelessWidget {
  const Sleepy({required this.title, required this.text});

  final String title, text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.black),
            )),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('5分くらい'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {},
                  )),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('10分くらい'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {},
                  )),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('20分くらい'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {},
                  )),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('30分以上'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {},
                  )),
            ],
          )
          ),
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
