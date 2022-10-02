import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePickerWidget extends StatefulWidget {
  final DateTime value;
  final ValueChanged<String?>? onChanged;
  const TimePickerWidget({Key? key, required this.value, this.onChanged}) : super(key: key);

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {
  dynamic dateTime;
  late final ValueChanged<String?> submitOnChanged;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    if(widget.onChanged != null) {
      submitOnChanged = widget.onChanged!;
    }
  }

  @override
  void didUpdateWidget(TimePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    dateTime = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 300,
        child: CupertinoDatePicker(
          key: UniqueKey(),
          backgroundColor: Colors.white,
          mode: CupertinoDatePickerMode.time,
          initialDateTime: dateTime,
          onDateTimeChanged: (dt) {
            setState(() => dateTime = dt);
            submitOnChanged(dt.toString());
          },
          use24hFormat: false,
          minuteInterval: 1,
        ));
  }
}
