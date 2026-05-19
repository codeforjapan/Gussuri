import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 3, kToday.month);

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
  final _loadedMonths = <String>{};
  Future<void>? _initialFuture;

  /// 起動時：前月・当月の2ヶ月だけ取得
  Future<void> loadEvents() {
    _initialFuture ??= _fetchMonths([
      DateTime(kToday.year, kToday.month - 1),
      DateTime(kToday.year, kToday.month),
    ]);
    return _initialFuture!;
  }

  /// カレンダーページ切替時：その月だけオンデマンド取得
  Future<void> loadMonth(DateTime month) {
    return _fetchMonths([DateTime(month.year, month.month)]);
  }

  Future<void> _fetchMonths(List<DateTime> months) async {
    // 取得前に即マーク → 並行呼び出しでも二重取得しない
    final toFetch = months.where((m) {
      final key = DateFormat('yyyy-MM').format(m);
      if (_loadedMonths.contains(key)) return false;
      _loadedMonths.add(key);
      return true;
    }).toList();
    if (toFetch.isEmpty) return;

    final deviceId = await DeviceData.getDeviceUniqueId();
    final snaps = await Future.wait(
      toFetch.map((date) => FirebaseFirestore.instance
          .collection(deviceId)
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get()),
    );
    for (var i = 0; i < toFetch.length; i++) {
      final date = toFetch[i];
      for (final res in snaps[i].docs) {
        final day = int.tryParse(res.id);
        if (day == null) continue;
        kEvents[DateTime.utc(date.year, date.month, day)] =
            [Event(res.data(), res.reference.path)];
      }
    }
    notifyListeners();
  }

  void updateEvent(Map<DateTime, List<Event>> newEvent) {
    kEvents = newEvent;
    notifyListeners();
  }

  void upsertEvent(DateTime date, Event event) {
    final key = DateTime.utc(date.year, date.month, date.day);
    kEvents[key] = [event];
    notifyListeners();
  }
}
