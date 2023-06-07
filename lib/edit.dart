import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/component/TimePicker.dart';
import 'package:gussuri/component/awake_form.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/component/image_buttons.dart';
import 'package:gussuri/component/input_card.dart';
import 'package:gussuri/component/slide_button.dart';
import 'package:gussuri/component/submit_button.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:intl/intl.dart';

class Edit extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic> sleepyData;
  final String deviceId;

  const Edit(this.date, this.sleepyData, this.deviceId, {super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late String _formattedDate;
  late String _deviceId;
  late Map<String, dynamic> _sleepyData;

  bool _checkSubmit() {
    for (final value in _sleepyData.values) {
      if (value == null || value == "") {
        return false;
      }
    }
    return true;
  }

  Future<void> _updateSleepyData() async {
    FirebaseFirestore.instance
        .collection(_deviceId) // コレクションID
        .doc(DateKey.year())
        .collection(DateKey.month())
        .doc(DateKey.day())
        .set(_sleepyData)
        .then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Calendar())));
  }

  DateTime convertDateTime(String datetime) {
    return DateTime.parse(datetime);
  }

  @override
  void initState() {
    super.initState();
    _sleepyData = widget.sleepyData;
    _deviceId = widget.deviceId;
    _formattedDate = DateFormat('yyyy年M月d日').format(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    const timePickerKey =
        GlobalObjectKey<TimePickerState>('__EDIT_TIME_PICKER_KEY__');
    const timePickerKeySecond =
        GlobalObjectKey<TimePickerState>('__EDIT_TIME_PICKER_KEY2__');
    const imageBoxKey =
        GlobalObjectKey<ImageButtonState>('__EDIT_IMAGE_BOX_KEY__');
    const imageBoxKeySecond =
        GlobalObjectKey<ImageButtonState>('__EDIT_IMAGE_BOX_KEY2__');
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: GradientBox(
                  child: Column(
                children: [
                  TitleBox(text: _formattedDate),
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
                              value:
                                  convertDateTime(_sleepyData["get_up_time"]),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["get_up_time"] = value;
                                    })
                                  }))),
                  InputCard(
                      title: '目覚めから布団を出るまで',
                      form: ImageButton(
                          value: _sleepyData['SOL'],
                          key: imageBoxKey,
                          onChanged: (value) {
                            setState(() {
                              _sleepyData['SOL'] = value;
                            });
                          })),
                  AwakeForm(
                    timesValue: _sleepyData['NOA'],
                    slideValue: _sleepyData['WASO'],
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
                          value: _sleepyData['TASAFA'],
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
                              value: convertDateTime(_sleepyData["bed_time"]),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["bed_time"] = value;
                                    })
                                  }))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SubmitButton(
                        buttonText: '編集保存',
                        onPressed: _checkSubmit()
                            ? () {
                                _updateSleepyData();
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
