import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
  String currentDay(DateTime selected) {
    return DateFormat("EEEE").format(selected);
  }
}