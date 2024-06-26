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
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Input extends StatefulWidget {
  final DateTime selectedDay;
  final Widget nextPage;

  const Input(this.selectedDay, {super.key, required this.nextPage});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  List<String> _targetDays = [];
  String formattedDate = DateFormat('yyyy年M月d日').format(DateTime.now());
  Map<String, dynamic> _sleepyData = {
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

  @override
  void initState() {
    super.initState();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    formattedDate = DateFormat('yyyy/M/d').format(widget.selectedDay);
    _targetDays = outputFormat.format(widget.selectedDay).split('-');
    _sleepyData = {
      "bed_time": DateTime(
          widget.selectedDay.year,
          widget.selectedDay.month,
          widget.selectedDay.day,
          22,
          0).toLocal(),
      "TASAFA": "",
      "get_up_time": DateTime(
          widget.selectedDay.year,
          widget.selectedDay.month,
          widget.selectedDay.day,
          9,
          0).toLocal(),
      "dysfunction": 4,
      "WASO": null,
      "SOL": "",
      "NOA": null
    };
  }

  Future<void> _createSleepyData() async {
    FirebaseFirestore.instance
        .collection(await DeviceData.getDeviceUniqueId()) // コレクションID
        .doc(_targetDays[0])
        .collection(_targetDays[1])
        .doc(_targetDays[2])
        .set(_sleepyData)
        .then((value) => Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => widget.nextPage),
            (_) => false));
  }

  final timePickerKey =
      const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY__');
  final timePickerKeySecond =
      const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY2__');
  final imageBoxKey =
      const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY__');
  final imageBoxKeySecond =
      const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY2__');

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                      title: localizations.inputGetUpTime,
                      form: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: TimePickerWidget(
                              key: timePickerKey,
                              value: DateTime(
                                  widget.selectedDay.year,
                                  widget.selectedDay.month,
                                  widget.selectedDay.day,
                                  9,
                                  0).toLocal(),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["get_up_time"] = value;
                                    })
                                  }))),
                  InputCard(
                      title: localizations.inputWakeingUp,
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
                      title: localizations.inputBetweenBedToSleep,
                      form: ImageButton(
                          key: imageBoxKeySecond,
                          onChanged: (value) {
                            setState(() {
                              _sleepyData['TASAFA'] = value;
                            });
                          })),
                  InputCard(
                      title: localizations.inputTimeInBed,
                      form: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: TimePickerWidget(
                              key: timePickerKeySecond,
                              value: DateTime(
                                  widget.selectedDay.year,
                                  widget.selectedDay.month,
                                  widget.selectedDay.day,
                                  22,
                                  0).toLocal(),
                              onChanged: (value) => {
                                    setState(() {
                                      _sleepyData["bed_time"] = value;
                                    })
                                  }))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SubmitButton(
                        buttonText: localizations.inputComplete,
                        onPressed: _checkSubmit()
                            ? () {
                                  timePickerKey.currentState?.finalizeChanges();
                                  timePickerKeySecond.currentState?.finalizeChanges();
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
