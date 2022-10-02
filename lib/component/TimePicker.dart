import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  final String value;

  const TimePickerWidget({Key? key, required this.value}) : super(key: key);

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {
  dynamic dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = TimeOfDay.now();
  }

  TimeOfDay parseTimeOfDay(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  @override
  void didUpdateWidget(TimePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    dateTime = parseTimeOfDay(widget.value);
  }

  _timePicker(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: dateTime,
    );
    if (timePicked != null && timePicked != dateTime) {
      setState(() {
        dateTime = timePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${dateTime.hour}時${dateTime.minute}分"),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 30),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              )),
          onPressed: () {
            _timePicker(context);
          },
          child: const Text("時刻を選択"),
        )
      ],
    ));
  }
}
