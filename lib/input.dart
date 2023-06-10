import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/TimePicker.dart';
import 'package:gussuri/component/awake_form.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/component/image_buttons.dart';
import 'package:gussuri/component/input_card.dart';
import 'package:gussuri/component/slide_button.dart';
import 'package:gussuri/component/submit_button.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/home.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  String formattedDate = DateFormat('yyyy年M月d日').format(DateTime.now());
  final Map<String, dynamic> _sleepyData = {
    "bed_time": DateTime.now(),
    "TASAFA": "",
    "get_up_time": DateTime.now(),
    "dysfunction": 4,
    "WASO": null,
    "SOL": "",
    "NOA": null
  };

  bool _checkSubmit() {
    for (final value in _sleepyData.values) {
      if (value == null || value == "") {
        return false;
      }
    }
    return true;
  }

  Future<void> _createSleepyData() async {
    FirebaseFirestore.instance
        .collection(await DeviceData.getDeviceUniqueId()) // コレクションID
        .doc(DateKey.year())
        .collection(DateKey.month())
        .doc(DateKey.day())
        .set(_sleepyData)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home())));
  }
  final timePickerKey =
  const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY__');
  final timePickerKeySecond =
  const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY2__');
  final imageBoxKey = const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY__');
  final imageBoxKeySecond =
  const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY2__');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: GradientBox(
                  child: Column(
                children: [
                  TitleBox(text: formattedDate),
                  SlideButton(
                    value: _sleepyData['dysfunction'],
                    onChanged: (value) {
                      setState(() {
                        _sleepyData['dysfunction'] = value;
                      });
                    },
                  ),
                  InputCard(
                      title: '布団を出た時間',
                      form: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: TimePickerWidget(
                              key: timePickerKey,
                              value: DateTime.now(),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["get_up_time"] = value;
                                    })
                                  }))),
                  InputCard(
                      title: '目覚めから布団を出るまで',
                      form: ImageButton(
                          key: imageBoxKey,
                          onChanged: (value) {
                            setState(() {
                              _sleepyData['SOL'] = value;
                            });
                          })),
                  AwakeForm(
                    onChangedTimes: (value) {
                      setState(() {
                        _sleepyData['NOA'] = value;
                      });
                    },
                    onChangedSlide: (value) {
                      setState(() {
                        _sleepyData['WASO'] = value;
                      });
                    },
                  ),
                  InputCard(
                      title: '布団に入ってから眠りにつくまで',
                      form: ImageButton(
                          key: imageBoxKeySecond,
                          onChanged: (value) {
                            setState(() {
                              _sleepyData['TASAFA'] = value;
                            });
                          })),
                  InputCard(
                      title: '布団に入った時間',
                      form: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: TimePickerWidget(
                              key: timePickerKeySecond,
                              value: DateTime.now(),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["bed_time"] = value;
                                    })
                                  }))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SubmitButton(
                        buttonText: '入力完了',
                        onPressed: _checkSubmit()
                            ? () {
                                _createSleepyData();
                              }
                            : null,
                      )
                    ],
                  )
                ],
              ))),
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(left: 20.w),
                child: Image.asset('images/baku-kun-2.png'),
              ))
        ]));
  }
}
