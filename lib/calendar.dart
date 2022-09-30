import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/home.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Icon _rightChevron = const Icon(Icons.chevron_right, color: Colors.grey);
  Icon _leftChevron = const Icon(Icons.chevron_left);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
              padding: EdgeInsets.only(left: 18.0.w),
              child: const Text(
                '睡眠記録シート',
                style: TextStyle(color: Colors.black),
              )),
          actions: [
            ElevatedButton(
              child: const Text('ホーム'),
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            )
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: TableCalendar(
          firstDay: kFirstDay,
          lastDay: kToday,
          focusedDay: _focusedDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronIcon: _leftChevron,
            rightChevronIcon: _rightChevron,
            titleCentered: true,
          ),
          locale: 'ja_JP',
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _rightChevron = isSameMonth(kToday, focusedDay)
                  ? const Icon(Icons.chevron_right, color: Colors.grey)
                  : const Icon(Icons.chevron_right);
              _leftChevron = isSameMonth(kFirstDay, focusedDay)
                  ? const Icon(Icons.chevron_left, color: Colors.grey)
                  : const Icon(Icons.chevron_left);
            });
            _focusedDay = focusedDay;
          },
        ));
  }
}
