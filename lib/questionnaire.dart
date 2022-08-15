import 'package:flutter/material.dart';
import 'package:gussuri/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Questionnaire extends StatelessWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  children: const [
                    Text('睡眠のお困りごとによる、今日一日の活動への支障度についてお尋ねいたします。'),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: SliderWidget(),
                    )
                  ],
                ),
              ),
            ],
          )),
          Container(
            width: double.infinity,
            height: 100.h,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Center(
              child: ElevatedButton(
                child: const Text('保存'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300.w, 60.h),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
                onPressed: () {
                  // todo ボタンのステータスを変更する必要がある
                  // firebaseにデータ同期
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
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
