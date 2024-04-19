import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

class TimePickerWidget extends StatefulWidget {
  final DateTime value;
  final ValueChanged<String?>? onChanged;
  const TimePickerWidget({Key? key, required this.value, this.onChanged}) : super(key: key);

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {

  late DateTime dateTime;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    dateTime = widget.value;
  }

  void _onDateTimeChanged(DateTime dt) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        dateTime = dt;
        if (widget.onChanged != null) {
          widget.onChanged!(dt.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: 300,
        child: CupertinoDatePicker(
          key: UniqueKey(),
          backgroundColor: Colors.white,
          mode: CupertinoDatePickerMode.time,
          initialDateTime: dateTime,
          onDateTimeChanged: _onDateTimeChanged,
          use24hFormat: true,
          minuteInterval: 1,
        ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
