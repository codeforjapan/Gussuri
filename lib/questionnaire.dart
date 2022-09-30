import 'package:flutter/material.dart';
import 'package:gussuri/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'helper/DateKey.dart';
import 'helper/DeviceData.dart';

class Questionnaire extends StatelessWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sliderKey = GlobalObjectKey<_SliderWidgetState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.only(left: 18.0.w),
            child: const Text(
              '昨夜の睡眠',
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
              child: const Text('保存'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300.w, 50.h),
                primary: Colors.white,
                onPrimary: Colors.black,
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(await DeviceData.getDeviceUniqueId()) // コレクションID
                    .doc(DateKey.year())
                    .collection(DateKey.month())
                    .doc(DateKey.day())
                    .set({
                  'dysfunction': sliderKey.currentState?.currentSliderValue
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                padding: EdgeInsets.fromLTRB(15.w, 100.h, 15.w, 10.h),
                width: 350.w,
                height: 150.h,
                child: Column(
                  children: const [Text('振り返ってみて、今日一日はいかがでしたか？')],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15.w, 100.h, 15.w, 10.h),
                width: 350.w,
                child: Column(
                  children: [
                    const Text('睡眠のお困りごとによる、今日一日の活動への支障度についてお尋ねいたします。'),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SliderWidget(key: sliderKey),
                    )
                  ],
                ),
              ),
            ],
          )),
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
  double currentSliderValue = 0;

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
            value: currentSliderValue,
            max: 10,
            divisions: 10,
            label: currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                currentSliderValue = value;
              });
            })
      ],
    );
  }
}
