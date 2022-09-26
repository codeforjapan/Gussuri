import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({Key? key}) : super(key: key);

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
