import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/sleepyEdit.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'input.dart';
import 'utils.dart';
import 'dart:math';

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

      if (_getEventsForDay(selectedDay) as bool) {
        // TODO: Edit pageへ変更
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Input()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Input()));
      }
    }
  }

  String _getImagePath(DateTime targetDay) {
    // TODO: その日の記録があるかどうかチェック
    var random = Random();
    int scoreNumber = random.nextInt(10);
    bool result = random.nextBool();

    if (result) {
      return 'images/evaluation_default.jpg';
    } else {
      return 'images/evaluation_$scoreNumber.jpg';
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
            return Event(
                DateFormat('MM/dd H:m')
                    .format(DateTime.parse(data['bed_time'])),
                DateFormat('MM/dd H:m')
                    .format(DateTime.parse(data['get_up_time'])),
                res.reference.path);
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
                  rangeHighlightBuilder: (context, day, focusedDay) {
                    final imgPath = _getImagePath(day);
                    final today = DateTime.now();
                    final todayDate =
                        DateTime(today.year, today.month, today.day);
                    final dayDate = DateTime(day.year, day.month, day.day);
                    if (dayDate.isAfter(todayDate)) {
                      return null;
                    }

                    return CustomCel(imgPath: imgPath, day: day.day);
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final imgPath = _getImagePath(day);

                    return CustomCel(imgPath: imgPath, day: day.day);
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final imgPath = _getImagePath(day);
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
                                    child: Image(
                                  image: AssetImage(imgPath),
                                  width: 28,
                                  height: 28,
                                )),
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
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SleepyEdit(
                                          {value: value},
                                          value: value[index].documentId,
                                        )))
                          },
                          title: Text(
                              'ベッドに入った時間: ${value[index].bedtime}\nベットから出た時間: ${value[index].getUpTime}'),
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

class CustomCel extends StatelessWidget {
  final String imgPath;
  final int day;

  const CustomCel({super.key, required this.imgPath, required this.day});

  @override
  Widget build(BuildContext context) {
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
                  child: Image(
                      image: AssetImage(imgPath),
                      width: 28,
                      height: 28,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Image not found');
                      })),
            )
          ],
        ),
      ),
    );
  }
}
