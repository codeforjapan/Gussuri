import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/calender.dart';
import 'package:gussuri/home.dart';

class Finish extends StatelessWidget {
  const Finish({Key? key}) : super(key: key);

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
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Text(
                  '記録しました',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: ElevatedButton(
                      child: const Text('睡眠記録シート'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(300.w, 80.h),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Calender()));
                      })),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('ホームへ戻る'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.w, 80.h),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                  )),
            ],
          )),
        ],
      ),
    );
  }
}
