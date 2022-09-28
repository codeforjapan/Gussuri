import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/home.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatelessWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
              padding: EdgeInsets.only(left: 18.0.w),
              child: const Text(
                '睡眠記録シート',
                style: TextStyle(color: Colors.black),
              )),
          actions: [
            ElevatedButton(
              child: const Text('ホーム'),
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            )
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
        ));
  }
}
