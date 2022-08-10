import 'package:flutter/material.dart';
import 'package:gussuri/main.dart';

class Questionnaire extends StatelessWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        centerTitle: false,
        title: const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text(
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
                padding: const EdgeInsets.fromLTRB(15, 100, 15, 10),
                width: 350,
                height: 150,
                child: Column(
                  children: const [Text('振り返ってみて、今日一日はいかがでしたか？')],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 100, 15, 10),
                width: 350,
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
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFF424242)),
            child: Center(
              child: ElevatedButton(
                child: const Text('保存'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 60),
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  (index) => const SizedBox(
                    height: 8,
                    child: VerticalDivider(
                      width: 8,
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
