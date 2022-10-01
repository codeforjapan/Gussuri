import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/recording.dart';
import 'package:gussuri/sleepyEdit.dart';
import './questionnaire.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool? _checkLastNightSleep;
  String _tips= '';

  Future<void> checkLastNightSleep() async {
    final orderSnap = await FirebaseFirestore.instance
        .collection(await DeviceData.getDeviceUniqueId())
        .doc(DateKey.year())
        .collection(DateKey.month())
        .doc(DateKey.day())
        .get();
    try {
      orderSnap.get('dysfunction');
      if (mounted) {
        setState(() {
          _checkLastNightSleep = true;
        });
      }
    } on StateError {
      if (mounted) {
        setState(() {
          _checkLastNightSleep = false;
        });
      }
    }
  }

  Future<void> getTips() async {
    var rand = math.Random();
    final tips = await FirebaseFirestore.instance
        .collection('tips')
        .doc(rand.nextInt(2).toString())
        .get();
    _tips = tips.get('content');
  }
  @override
  void initState() {
    super.initState();
    checkLastNightSleep();
    getTips();
  }

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
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF424242),
        child: SizedBox(
          width: double.infinity,
          height: 65.h,
          child: Center(
            child: ElevatedButton(
              child: const Text('睡眠記録シート'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300.w, 50.h),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Calendar()));
              },
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(30.h),
                  child: ElevatedButton(
                    child: const Text('昨日の睡眠'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(315.w, 100.h),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _checkLastNightSleep == false
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Questionnaire()));
                          }
                        : null,
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
                        child: const Text('Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Text(_tips)
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: ElevatedButton(
                    child: const Text('布団に入ります'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.w, 140.h),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _checkLastNightSleep == true
                        ? () async {
                            FirebaseFirestore.instance
                                .collection(await DeviceData
                                    .getDeviceUniqueId()) // コレクションID
                                .doc(DateKey.year())
                                .collection(DateKey.month())
                                .doc(DateKey.day())
                                .set({
                              'bed_time': DateKey.datetimeFormat(),
                            }, SetOptions(merge: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Recording(tips: _tips,)));
                          }
                        : null,
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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SleepyEdit()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
