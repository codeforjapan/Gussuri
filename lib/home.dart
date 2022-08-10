import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: const Text(
              'ホーム',
              style: TextStyle(color: Colors.black),
            )),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(30.h),
                  child: ElevatedButton(
                    child: const Text('昨日の睡眠'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(315.w, 100.h),
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
                padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                width: double.infinity,
                height: 130.h,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(bottom: 5.h),
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
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: ElevatedButton(
                    child: const Text('布団に入ります'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.w, 140.h),
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
            height: 100.h,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Center(
              child: ElevatedButton(
                child: const Text('睡眠記録シート'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300.w, 60.h),
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
