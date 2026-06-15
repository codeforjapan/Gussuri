import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/component/TimePicker.dart';
import 'package:gussuri/component/awake_form.dart';
import 'package:gussuri/component/gradient_box.dart';
import 'package:gussuri/component/image_buttons.dart';
import 'package:gussuri/component/input_card.dart';
import 'package:gussuri/component/slide_button.dart';
import 'package:gussuri/component/submit_button.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/utils.dart';
import 'package:provider/provider.dart';
import 'gen_l10n/app_localizations.dart';

class Edit extends StatefulWidget {
  final Map<String, dynamic> sleepyData;
  final String path;

  const Edit(this.sleepyData, this.path, {super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late String _formattedDate;
  List<String> _paths = [];
  late Map<String, dynamic> _sleepyData;

  // 定数キー: build() をまたいで同一インスタンスを参照するために State フィールドとして定義
  final _getUpTimeKey = const GlobalObjectKey<TimePickerState>('__EDIT_GET_UP_TIME_KEY__');
  final _bedTimeKey   = const GlobalObjectKey<TimePickerState>('__EDIT_BED_TIME_KEY__');

  bool _checkSubmit() {
    for (final value in _sleepyData.values) {
      if (value == null || value == "") {
        return false;
      }
    }
    return true;
  }

  Future<void> _updateSleepyData() async {
    final ref = FirebaseFirestore.instance
        .collection(_paths[0])
        .doc(_paths[1])
        .collection(_paths[2])
        .doc(_paths[3]);
    await ref.set(_sleepyData);
    if (!mounted) return;
    final date = DateTime(
      int.parse(_paths[1]),
      int.parse(_paths[2]),
      int.parse(_paths[3]),
    );
    Provider.of<CalenderState>(context, listen: false)
        .upsertEvent(date, Event(_sleepyData, ref.path));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Calendar()));
  }

  DateTime convertDateTime(dynamic datetime) {
    if (datetime is String) {
      return DateTime.parse(datetime);
    } else if (datetime is Timestamp) {
      return datetime.toDate();
    } else {
      return datetime;
    }
  }

  @override
  void initState() {
    super.initState();
    _sleepyData = widget.sleepyData;
    _paths = widget.path.split('/');
    _formattedDate = '${_paths[1]}年${_paths[2]}月${_paths[3]}日';
  }

  void _onSubmit() {
    _getUpTimeKey.currentState?.finalizeChanges();
    _bedTimeKey.currentState?.finalizeChanges();
    _updateSleepyData();
  }

  Widget _buildFormItems(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TitleBox(text: _formattedDate),
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
              key: _getUpTimeKey,
              value: convertDateTime(_sleepyData["get_up_time"]),
              onChanged: (value) => setState(() => _sleepyData["get_up_time"] = value),
            ),
          ),
        ),
        InputCard(
          title: l.inputWakeingUp,
          form: ImageButton(
            value: _sleepyData['SOL'],
            key: const GlobalObjectKey<ImageButtonState>('__EDIT_SOL_KEY__'),
            onChanged: (value) => setState(() => _sleepyData['SOL'] = value),
          ),
        ),
        AwakeForm(
          timesValue: _sleepyData['NOA'],
          slideValue: _sleepyData['WASO'],
          onChangedTimes: (value) => setState(() => _sleepyData['NOA'] = value),
          onChangedSlide: (value) => setState(() => _sleepyData['WASO'] = value),
        ),
        InputCard(
          title: l.inputBetweenBedToSleep,
          form: ImageButton(
            value: _sleepyData['TASAFA'],
            key: const GlobalObjectKey<ImageButtonState>('__EDIT_TASAFA_KEY__'),
            onChanged: (value) => setState(() => _sleepyData['TASAFA'] = value),
          ),
        ),
        InputCard(
          title: l.inputTimeInBed,
          form: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            child: TimePickerWidget(
              key: _bedTimeKey,
              value: convertDateTime(_sleepyData["bed_time"]),
              onChanged: (value) => setState(() => _sleepyData["bed_time"] = value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPanel(AppLocalizations l) {
    final bed = convertDateTime(_sleepyData['bed_time']);
    final getUp = convertDateTime(_sleepyData['get_up_time']);
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
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
              child: Text(l.editComplete),
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
                        buttonText: localizations.editComplete,
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
