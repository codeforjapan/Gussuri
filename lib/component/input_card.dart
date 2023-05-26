import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputCard extends StatelessWidget {
  const InputCard({super.key, required this.form, required this.title});
  final String title;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 10.h, right: 20.w, left: 20.w),
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child:  Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          form
        ]));
  }
}
