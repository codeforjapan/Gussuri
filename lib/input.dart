import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/calendar.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: const Text(
              '',
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
      body: Container(
          width: double.infinity,
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
                child: SingleChildScrollView(
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
                                  onPressed: null,
                                  child: const Text('button'),
                                )
                              ),
                            ]
                        )
                )
            )
          ],
        )
      ),
    );
  }
}
