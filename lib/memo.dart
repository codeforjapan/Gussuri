import 'package:flutter/material.dart';
import 'package:gussuri/finish.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home.dart';

class Memo extends StatelessWidget {
  const Memo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: const Text(
              '一言メモ',
              style: TextStyle(color: Colors.black),
            )),
        actions: [
          ElevatedButton(
            child: const Text('ホーム'),
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageDart()));
            },
          )
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15.w, 100.h, 15.w, 10.h),
                width: 350.w,
                height: 150.h,
                child: Column(
                  children: const [Text('今日の睡眠に関連しそうなこと')],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35.w, right: 35.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350.w,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'プレースホルダー',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),

                  ),
                  maxLines: 15,
                  minLines: 15,
                ),
              ),
            ],
          )),
          Container(
            width: double.infinity,
            height: 80.h,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 28.0.w),
                    child: ElevatedButton(
                        child: const Text('前へ'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(70.w, 50.h),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop()
                    )),
                Padding(
                  padding: EdgeInsets.only(right: 28.0.w),
                  child: ElevatedButton(
                    child: const Text('次へ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(70.w, 50.h),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Finish()));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(11, (index) => Text('$index')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  16,
                  (index) => SizedBox(
                    height: 8.h,
                    child: VerticalDivider(
                      width: 8.w,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Slider(
            value: _currentSliderValue,
            max: 10,
            divisions: 10,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            })
      ],
    );
  }
}
