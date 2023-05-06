import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/component/header.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/input.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool? _checkLastNightSleep;
  String _tips = '';

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
      backgroundColor: Colors.transparent,
      appBar: const Header(),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF424242),
        child: SizedBox(
          width: double.infinity,
          height: 65.h,
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300.w, 50.h),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Calendar()));
              },
              child: const Text('睡眠記録シート'),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xffffefc7),
                  Color(0xffa4e9ff),
                  Color(0xff6cb9ff),
                  Color(0xff180077),
                  Color(0xff001637),
        ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(30.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(280.w, 80.h),
                        backgroundColor: const Color(0xffFFD069),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                      ),
                      onPressed: _checkLastNightSleep == false
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Input()));
                            }
                          : null,
                      child: const Text('睡眠記録'),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 0.h),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(280.w, 50.h),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                      ),

                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Calendar()));
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('睡眠記録カレンダー'),
                    )),
              ],
            )),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
              margin: EdgeInsets.only(bottom: 80.h, left: 20.w, right: 20.w),
              width: double.infinity,
              height: 130.h,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: const Text('gussuriチャレンジ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                  Text(_tips)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
