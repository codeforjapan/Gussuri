import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/header.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/sleepyEdit.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.utc(kToday.year, kToday.month, kToday.day);
  DateTime? _selectedDay;
  Icon _rightChevron = const Icon(Icons.chevron_right, color: Colors.grey);
  Icon _leftChevron = const Icon(Icons.chevron_left);

  @override
  void initState() {
    super.initState();

    setEvents();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  Future<void> setEvents() async {
    for (var index = 0; index < 2; index++) {
      DateTime _date = DateTime(kFirstDay.year, kFirstDay.month + index);
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc('${_date.year}')
          .collection(DateFormat('MM').format(_date))
          .get();
      orderSnap.docs.map((e) => e).forEach((res) {
        final data = res.data();
        kEvents.addAll({
          DateTime.utc(_date.year, _date.month, int.parse(res.id)):
          List.generate(1, (index) {
            return Event(
                DateFormat('MM/dd H:m').format(DateTime.parse(data['bed_time'])),
                DateFormat('MM/dd H:m').format(DateTime.parse(data['get_up_time'])),
                res.reference.path
            );
          })
        });
      });
    }
    _selectedEvents.value = _getEventsForDay(_focusedDay);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const Header(),
        body: Column(
          children: [
            TableCalendar(
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
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,
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
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepyEdit({value: value}, value: value[index].documentId,)))
                          },
                          title: Text('ベッドに入った時間: ${value[index].bedtime}\nベットから出た時間: ${value[index].getUpTime}'),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }
}
