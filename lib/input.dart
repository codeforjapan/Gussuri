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
import 'package:gussuri/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'gen_l10n/app_localizations.dart';

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
    final deviceId = await DeviceData.getDeviceUniqueId();
    final ref = FirebaseFirestore.instance
        .collection(deviceId)
        .doc(_targetDays[0])
        .collection(_targetDays[1])
        .doc(_targetDays[2]);
    await ref.set(_sleepyData);
    if (!mounted) return;
    Provider.of<CalenderState>(context, listen: false)
        .upsertEvent(widget.selectedDay, Event(_sleepyData, ref.path));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
        (_) => false);
  }

  final timePickerKey =
      const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY__');
  final timePickerKeySecond =
      const GlobalObjectKey<TimePickerState>('__TIME_PICKER_KEY2__');
  final imageBoxKey =
      const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY__');
  final imageBoxKeySecond =
      const GlobalObjectKey<ImageButtonState>('__IMAGE_BOX_KEY2__');

  void _onSubmit() {
    timePickerKey.currentState?.finalizeChanges();
    timePickerKeySecond.currentState?.finalizeChanges();
    _createSleepyData();
  }

  Widget _buildFormItems(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TitleBox(text: formattedDate),
        SlideButton(
          value: _sleepyData['dysfunction'],
          onChanged: (value) => setState(() => _sleepyData['dysfunction'] = value),
        ),
        InputCard(
          title: l.inputGetUpTime,
          form: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            child: TimePickerWidget(
              key: timePickerKey,
              value: DateTime(widget.selectedDay.year, widget.selectedDay.month,
                  widget.selectedDay.day, 9, 0).toLocal(),
              onChanged: (value) => setState(() => _sleepyData["get_up_time"] = value),
            ),
          ),
        ),
        InputCard(
          title: l.inputWakeingUp,
          form: ImageButton(
            key: imageBoxKey,
            onChanged: (value) => setState(() => _sleepyData['SOL'] = value),
          ),
        ),
        AwakeForm(
          onChangedTimes: (value) => setState(() => _sleepyData['NOA'] = value),
          onChangedSlide: (value) => setState(() => _sleepyData['WASO'] = value),
        ),
        InputCard(
          title: l.inputBetweenBedToSleep,
          form: ImageButton(
            key: imageBoxKeySecond,
            onChanged: (value) => setState(() => _sleepyData['TASAFA'] = value),
          ),
        ),
        InputCard(
          title: l.inputTimeInBed,
          form: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            child: TimePickerWidget(
              key: timePickerKeySecond,
              value: DateTime(widget.selectedDay.year, widget.selectedDay.month,
                  widget.selectedDay.day, 22, 0).toLocal(),
              onChanged: (value) => setState(() => _sleepyData["bed_time"] = value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPanel(AppLocalizations l) {
    final bed = _sleepyData['bed_time'] as DateTime;
    final getUp = _sleepyData['get_up_time'] as DateTime;
    var dur = getUp.difference(bed);
    if (dur.isNegative) dur += const Duration(days: 1);
    final hours = dur.inHours;
    final mins = dur.inMinutes % 60;
    final durStr = mins > 0 ? '$hours時間$mins分' : '$hours時間';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'images/evaluation_${_sleepyData['dysfunction']}.jpg',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l.rate} ${_sleepyData['dysfunction']}',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _summaryRow('🌙', l.inputTimeInBed, DateFormat('HH:mm').format(bed)),
                _summaryRow('☀️', l.inputGetUpTime, DateFormat('HH:mm').format(getUp)),
                _summaryRow('💤', '睡眠時間', durStr),
                const SizedBox(height: 8),
                if ((_sleepyData['SOL'] ?? '') != '')
                  _summaryRow('⏱', l.inputWakeingUp,
                      (_sleepyData['SOL'] as String).replaceAll('\n', ' ')),
                if (_sleepyData['NOA'] != null)
                  _summaryRow('👁', l.inputAwakeingAfter, '${_sleepyData['NOA']}回'),
                if ((_sleepyData['WASO'] ?? '') != '')
                  _summaryRow('🕐', l.inputWasoLabel,
                      (_sleepyData['WASO'] as String).replaceAll('\n', ' ')),
                if ((_sleepyData['TASAFA'] ?? '') != '')
                  _summaryRow('🛏', l.inputBetweenBedToSleep,
                      (_sleepyData['TASAFA'] as String).replaceAll('\n', ' ')),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _checkSubmit() ? _onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFFD069),
                foregroundColor: Colors.black,
                disabledForegroundColor: const Color(0xFF101326),
                disabledBackgroundColor: const Color(0xFF6D5F44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(l.inputComplete),
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (isTablet(context)) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBox(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: _buildFormItems(localizations),
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
              Expanded(
                flex: 2,
                child: Container(
                  color: const Color(0xFF001637),
                  child: _buildSummaryPanel(localizations),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Stack(children: [
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: GradientBox(
                  child: Column(
                children: [
                  _buildFormItems(localizations),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SubmitButton(
                        buttonText: localizations.inputComplete,
                        onPressed: _checkSubmit() ? _onSubmit : null,
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
        ]),
          ),
        ),
    );
  }
}
