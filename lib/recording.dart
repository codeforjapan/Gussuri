import 'package:flutter/material.dart';

class Recording extends StatelessWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
              '記録中',
              style: TextStyle(color: Colors.black),
            )),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text('布団から出ました'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 180),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
