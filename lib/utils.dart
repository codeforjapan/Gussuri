final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 1);

bool isSameMonth(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month;
}

/// Example event class.
class Event {
  final String bedtime;
  final String getUpTime;

  const Event(this.bedtime, this.getUpTime);
}

final kEvents = <DateTime, List<Event>>{};

