import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/enums/TabItem.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/input.dart';
import 'dart:math' as math;
import 'package:gussuri/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final Function? updateIndex;

  const Home({Key? key, this.updateIndex}) : super(key: key);

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

  Future<void> getEvents(context) async {
    Map<DateTime, List<Event>> eventData = {};
    for (var index = 0; index < 2; index++) {
      DateTime date = DateTime(kFirstDay.year, kFirstDay.month + index);
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get();
      orderSnap.docs.map((e) => e).forEach((res) {
        final data = res.data();
        eventData.addAll({
          DateTime.utc(date.year, date.month, int.parse(res.id)):
              List.generate(1, (index) {
            return Event(data, res.reference.path);
          })
        });
      });
    }
    Provider.of<CalenderState>(context, listen: false).updateEvent(eventData);
  }

  @override
  void initState() {
    super.initState();
    getEvents(context);
    checkLastNightSleep();
    getTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBox(
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
                              borderRadius: BorderRadius.circular(50)),
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      onPressed: _checkLastNightSleep == false
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Input(DateTime.now())));
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
                          textStyle: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        widget.updateIndex?.call(1, TabItem.calender);
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('睡眠記録カレンダー'),
                    )),
              ],
            )),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 10.h),
              margin: EdgeInsets.only(bottom: 0.h, left: 20.w, right: 20.w),
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
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20.w),
              child: Image.asset('images/baku-kun-1.png'),
            )
          ],
        ),
      ),
    );
  }
}
