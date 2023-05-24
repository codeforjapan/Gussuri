import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/component/title_box.dart';
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
