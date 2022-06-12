import 'package:flutter/material.dart';

class HomePageDart extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
          child: Column(children: [
        Container(
            width: 300,
            height: 80,
            margin: const EdgeInsets.all(15),
            child: ElevatedButton(
              child: const Text('ベッドに入った時間'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            )),
        Container(
            width: 300,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('入眠時間'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            )),
        Container(
            width: 300,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('目覚めた時間'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            )),
        Container(
            width: 300,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('ベッドから出た時間'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            )),
        Container(
            width: 300,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('中途覚醒'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            )),
      ])),
    );
  }
}
