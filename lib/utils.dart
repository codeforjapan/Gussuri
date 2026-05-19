import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';

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
  // Caches the in-flight Future so concurrent callers share the same load.
  Future<void>? _loadFuture;

  /// Loads events once; subsequent calls are no-ops until [reloadEvents] is called.
  Future<void> loadEvents() {
    _loadFuture ??= _fetchEvents();
    return _loadFuture!;
  }

  /// Forces a fresh fetch from Firestore.
  Future<void> reloadEvents() {
    _loadFuture = _fetchEvents();
    return _loadFuture!;
  }

  Future<void> _fetchEvents() async {
    final deviceId = await DeviceData.getDeviceUniqueId();
    final months = List.generate(
      2,
      (i) => DateTime(kFirstDay.year, kFirstDay.month + i),
    );
    final snaps = await Future.wait(
      months.map((date) => FirebaseFirestore.instance
          .collection(deviceId)
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get()),
    );
    final Map<DateTime, List<Event>> eventData = {};
    for (var i = 0; i < months.length; i++) {
      final date = months[i];
      for (final res in snaps[i].docs) {
        eventData[DateTime.utc(date.year, date.month, int.parse(res.id))] =
            [Event(res.data(), res.reference.path)];
      }
    }
    updateEvent(eventData);
  }

  void updateEvent(Map<DateTime, List<Event>> newEvent) {
    kEvents = newEvent;
    notifyListeners();
  }
}
