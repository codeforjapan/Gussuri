import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/edit.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'input.dart';
import 'utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calendar extends StatefulWidget {
  final Function? updateIndex;

  const Calendar({Key? key, this.updateIndex}) : super(key: key);

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
    getEvents(context);
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
          context, MaterialPageRoute(builder: (context) => Input(selectedDay, nextPage: const Calendar())));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Edit(events.first.sleepyData, events.first.documentId)));
    }
  }

  Future<void> getEvents(context) async {
    Map<DateTime, List<Event>> eventData = {};
    for (var index = 0; index < 2; index++) {
      DateTime date = DateTime(kFirstDay.year, kFirstDay.month + index);
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get();
      orderSnap.docs.map((e) => e).forEach((res) {
        final data = res.data();
        eventData.addAll({
          DateTime.utc(date.year, date.month, int.parse(res.id)):
          List.generate(1, (index) {
            return Event(data, res.reference.path);
          })
        });
      });
    }
    Provider.of<CalenderState>(context, listen: false).updateEvent(eventData);
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

  @override
  Widget build(BuildContext context) {
    Provider.of<CalenderState>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TitleBox(text: AppLocalizations.of(context)?.calendar ?? '睡眠記録カレンダー'),
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
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
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
                locale: Localizations.localeOf(context).languageCode,
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
                child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20.w),
              child: Image.asset('images/baku-kun-1.png'),
            )),
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
