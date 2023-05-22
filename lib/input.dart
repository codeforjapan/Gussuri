import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/component/GradientBox.dart';
import 'package:gussuri/component/TitleBox.dart';
import 'package:gussuri/component/header.dart';
import 'package:intl/intl.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  String formattedDate = DateFormat('yyyy年M月d日').format(DateTime.now());

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
                child: const Text('睡眠記録シート'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300.w, 50.h),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Calendar()));
                },
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: GradientBox(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TitleBox(text: formattedDate),
            Column(children: [
              Container(
                  padding: EdgeInsets.all(30.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(50, (ind) {
                      return ListTile(
                        title: Text('$ind'),
                      );
                    }).toList(),
                  )
              ),
            ])
          ],
        ))));
  }
}
