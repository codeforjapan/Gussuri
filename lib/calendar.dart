import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/edit.dart';
import 'package:gussuri/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'input.dart';
import 'gen_l10n/app_localizations.dart';

class Calendar extends StatefulWidget {
  final Function? updateIndex;

  const Calendar({super.key, this.updateIndex});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.utc(kToday.year, kToday.month, kToday.day);
  late DateTime _selectedDay;
  Icon _rightChevron = const Icon(Icons.chevron_right, color: Colors.grey);
  Icon _leftChevron = const Icon(Icons.chevron_left);
  Color selectedColor = const Color.fromRGBO(177, 208, 255, 1);

  // タブレット右パネル用
  DateTime? _panelDay;
  List<Event> _panelEvents = [];

  @override
  void initState() {
    super.initState();
    Provider.of<CalenderState>(context, listen: false).loadEvents();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
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

    if (isTablet(context)) {
      setState(() {
        _panelDay = selectedDay;
        _panelEvents = events;
      });
      return;
    }

    if (events.isEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Input(selectedDay, nextPage: const Calendar())));
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

  Widget _buildCalendar() {
    return SizedBox(
      height: isTablet(context) ? double.infinity : 400,
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
            return const Text('');
          },
          outsideBuilder: (context, day, focusedDay) {
            return const Text('');
          },
          todayBuilder: (context, day, focusedDay) {
            return const Text('');
          },
          markerBuilder: (context, day, focusedDay) {
            return const Text('');
          },
          singleMarkerBuilder: (context, day, focusedDay) {
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
                    mainAxisSize: MainAxisSize.min,
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
          context.read<CalenderState>().loadMonth(focusedDay);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CalenderState>(context);

    if (isTablet(context)) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TitleBox(
                text: AppLocalizations.of(context)?.calendar ??
                    '睡眠記録カレンダー'),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCalendar()),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: _DetailPanel(
                      selectedDay: _panelDay,
                      events: _panelEvents,
                      onRecord: _panelDay == null
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Input(
                                        _panelDay!,
                                        nextPage: const Calendar())),
                              ).then((_) {
                                if (mounted) {
                                  setState(() {
                                    _panelEvents = _getEventsForDay(_panelDay!);
                                  });
                                }
                              }),
                      onEdit: (_panelDay == null || _panelEvents.isEmpty)
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Edit(
                                        _panelEvents.first.sleepyData,
                                        _panelEvents.first.documentId)),
                              ).then((_) {
                                if (mounted) {
                                  setState(() {
                                    _panelEvents = _getEventsForDay(_panelDay!);
                                  });
                                }
                              }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TitleBox(
                text: AppLocalizations.of(context)?.calendar ??
                    '睡眠記録カレンダー'),
            _buildCalendar(),
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

// ─── 右パネル ───────────────────────────────────────────────

class _DetailPanel extends StatelessWidget {
  final DateTime? selectedDay;
  final List<Event> events;
  final VoidCallback? onRecord;
  final VoidCallback? onEdit;

  const _DetailPanel({
    required this.selectedDay,
    required this.events,
    required this.onRecord,
    required this.onEdit,
  });

  String _formatTime(dynamic value) {
    try {
      DateTime dt;
      if (value is Timestamp) {
        dt = value.toDate();
      } else if (value is DateTime) {
        dt = value;
      } else {
        dt = DateTime.parse(value.toString()).toLocal();
      }
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (selectedDay == null) {
      return Center(
        child: Text(
          localizations.calendarSelectDate,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.calendarNoRecord,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFFD069),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: onRecord,
              child: Text(localizations.record),
            ),
          ],
        ),
      );
    }

    final data = events.first.sleepyData;
    final dysfunction = data['dysfunction'] ?? 0;

    // 睡眠時間を計算
    String sleepDuration = '--';
    try {
      final bed = _formatTime(data['bed_time']);
      final getUp = _formatTime(data['get_up_time']);
      if (bed != '--:--' && getUp != '--:--') {
        DateTime bedDt;
        DateTime getUpDt;
        final raw = data['bed_time'];
        if (raw is Timestamp) {
          bedDt = raw.toDate();
        } else if (raw is DateTime) {
          bedDt = raw;
        } else {
          bedDt = DateTime.parse(raw.toString()).toLocal();
        }
        final raw2 = data['get_up_time'];
        if (raw2 is Timestamp) {
          getUpDt = raw2.toDate();
        } else if (raw2 is DateTime) {
          getUpDt = raw2;
        } else {
          getUpDt = DateTime.parse(raw2.toString()).toLocal();
        }
        var dur = getUpDt.difference(bedDt);
        if (dur.isNegative) dur += const Duration(days: 1);
        final h = dur.inHours;
        final m = dur.inMinutes % 60;
        sleepDuration = m > 0 ? '$h時間$m分' : '$h時間';
      }
    } catch (_) {}

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 日付 + 休養スコア
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('yyyy/M/d').format(selectedDay!),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ClipOval(
                child: Image.asset(
                  'images/evaluation_$dysfunction.jpg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${localizations.rate} ${10 - (dysfunction as int)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: localizations.inputTimeInBed, value: _formatTime(data['bed_time'])),
          _SummaryRow(label: localizations.inputGetUpTime, value: _formatTime(data['get_up_time'])),
          _SummaryRow(label: '睡眠時間', value: sleepDuration),
          const Divider(height: 20),
          _SummaryRow(
              label: localizations.inputWakeingUp,
              value: '${data['SOL'] ?? '--'}'),
          _SummaryRow(
              label: localizations.inputBetweenBedToSleep,
              value: '${data['TASAFA'] ?? '--'}'),
          _SummaryRow(
              label: localizations.inputAwakeingAfter,
              value: '${data['NOA'] ?? '--'}'),
          _SummaryRow(
              label: localizations.inputWasoLabel,
              value: '${data['WASO'] ?? '--'}'),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFFD069),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: onEdit,
            child: Text(localizations.edit),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
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
