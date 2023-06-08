import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/edit.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'input.dart';
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
  Color selectedColor = const Color.fromRGBO(177, 208, 255, 1);

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
    }
    final events = _getEventsForDay(selectedDay);

    if (events.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Input()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Edit(events.first.sleepyData, events.first.documentId)));
    }
  }

  String _getImagePath(DateTime targetDay) {
    final events = _getEventsForDay(targetDay);
    if (events.isEmpty) {
      return 'images/evaluation_default.jpg';
    } else {
      var dysfunction = events.first.sleepyData['dysfunction'];
      return 'images/evaluation_$dysfunction.jpg';
    }
  }

  Future<void> setEvents() async {
    for (var index = 0; index < 2; index++) {
      DateTime date = DateTime(kFirstDay.year, kFirstDay.month + index);
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get();
      orderSnap.docs.map((e) => e).forEach((res) {
        final data = res.data();
        kEvents.addAll({
          DateTime.utc(date.year, date.month, int.parse(res.id)):
              List.generate(1, (index) {
            return Event(data, res.reference.path);
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
        body: Column(
          children: [
            const TitleBox(text: '睡眠記録カレンダー'),
            SizedBox(
              height: 400,
              child: TableCalendar(
                shouldFillViewport: true,
                firstDay: kFirstDay,
                lastDay: kToday,
                focusedDay: _focusedDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronIcon: _leftChevron,
                  rightChevronIcon: _rightChevron,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    // NOTE: defaultの日付が出てしまうため
                    return const Text('');
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    // NOTE: defaultの日付が出てしまうため
                    return const Text('');
                  },
                  todayBuilder: (context, day, focusedDay) {
                    // NOTE: defaultの日付が出てしまうため
                    return const Text('');
                  },
                  markerBuilder: (context, day, focusedDay) {
                    // NOTE: defaultの日付が出てしまうため
                    return const Text('');
                  },
                  singleMarkerBuilder: (context, day, focusedDay) {
                    // NOTE: defaultの日付が出てしまうため
                    return const Text('');
                  },
                  rangeHighlightBuilder: (context, day, focusedDay) {
                    final imgPath = _getImagePath(day);
                    final today = DateTime.now();
                    final todayDate =
                        DateTime(today.year, today.month, today.day);
                    final dayDate = DateTime(day.year, day.month, day.day);
                    if (dayDate.isBefore(todayDate) || dayDate == todayDate) {
                      return CustomCel(imgPath: imgPath, day: day.day);
                    }
                    return null;
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final imgPath = _getImagePath(day);
                    final imgOpacity =
                        imgPath == 'images/evaluation_default.jpg' ? 0.3 : 1.0;
                    // NOTE:選択された時だけレイアウトが違うので共通化してない
                    return SizedBox(
                      width: 200,
                      height: 250,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${day.day}',
                                style: const TextStyle().copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 2),
                                child: ClipOval(
                                  child: Opacity(
                                      opacity: imgOpacity,
                                      child: Image(
                                        image: AssetImage(imgPath),
                                        width: 28,
                                        height: 28,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
                          title: Text(
                              'ベッドに入った時間: ${value[index].sleepyData['bed_time']}\nベットから出た時間: ${value[index].sleepyData['get_up_time']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20.w),
              child: Image.asset('images/baku-kun-1.png'),
            )
          ],
        ));
  }
}

class CustomCel extends StatelessWidget {
  final String imgPath;
  final int day;

  const CustomCel({super.key, required this.imgPath, required this.day});

  @override
  Widget build(BuildContext context) {
    final imgOpacity = imgPath == 'images/evaluation_default.jpg' ? 0.3 : 1.0;

    return SizedBox(
      width: 200,
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              day.toString(),
              style: const TextStyle()
                  .copyWith(fontSize: 13.0, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2),
              child: ClipOval(
                child: Opacity(
                    opacity: imgOpacity,
                    child: Image(
                        image: AssetImage(imgPath),
                        width: 28,
                        height: 28,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Image not found');
                        })),
              ),
            )
          ],
        ),
      ),
    );
  }
}
