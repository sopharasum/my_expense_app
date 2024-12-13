import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(value) {
    final currencyFormat = new NumberFormat("#,##0", "en_US");
    return currencyFormat.format(value);
  }

  static String monthYearFormat(String date) {
    final dateFormat = DateFormat("dd-MM-yyyy");
    final convertedDate = dateFormat.parse(date);
    return DateFormat("MM-yyyy").format(convertedDate);
  }

  static String fullMonthYearFormat(DateTime dateTime) {
    return DateFormat("MMMM, yyyy").format(dateTime);
  }

  static String fullYearFormat(DateTime dateTime) {
    return DateFormat("yyyy").format(dateTime);
  }

  static String monthFormat(DateTime dateTime) {
    return DateFormat("MM").format(dateTime);
  }

  static String yearMonthFormat(DateTime dateTime) {
    return DateFormat("yyyy-MM").format(dateTime);
  }

  static String dayFormat(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  static String hourFormat(String? dateTime) {
    final local = DateTime.parse(dateTime ?? "").toLocal();
    return DateFormat("hh:mm a").format(local);
  }

  static String dateHourFormat(String? dateTime) {
    final local = DateTime.parse(dateTime ?? "").toLocal();
    return DateFormat("dd-MM-yyyy hh:mm a").format(local);
  }

  static String fullDateHourFormat(String? dateTime, String _format) {
    final local = DateTime.parse(dateTime ?? "").toLocal();
    return DateFormat(_format).format(local);
  }

  static String dateFormat(DateTime dateTime) {
    return DateFormat("EEEE dd MMMM yyyy").format(dateTime);
  }

  static String dateFormatWithDash(DateTime dateTime) {
    return DateFormat("dd-MMMM-yyyy").format(dateTime);
  }

  static String dateToString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }

  static String dateToStringLocal(String dateTime) {
    final local = DateTime.parse(dateTime).toLocal();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(local);
  }

  static String dateOnlyToString(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
