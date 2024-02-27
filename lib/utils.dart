import 'package:flutter/material.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 1);

bool isSameMonth(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month;
}

class Event {
  Map<String, dynamic> sleepyData = {
    "bed_time": DateTime.now(),
    "TASAFA": "",
    "get_up_time": DateTime.now(),
    "dysfunction": null,
    "WASO": null,
    "SOL": "",
    "NOA": null
  };
  final String documentId;

  Event(this.sleepyData, this.documentId);
}

Map<DateTime, List<Event>> kEvents = <DateTime, List<Event>>{};

class CalenderState with ChangeNotifier {
  void updateEvent(Map<DateTime, List<Event>> newEvent) {
    kEvents = newEvent;
    notifyListeners();
  }
}