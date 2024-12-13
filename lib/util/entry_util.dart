import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/config/khmer_date.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/day_of_week.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class EntryUtil {
  static String getCurrency(String? currency, double? amount) {
    return currency == "KHR"
        ? "${Formatter.formatCurrency(amount)}៛"
        : "${amount?.toStringAsFixed(amount % 1 == 0 ? 0 : 2)}\$";
  }

  static String showDateTime(String? language, String? dateTime) {
    return language == "km"
        ? formatDateTime(dateTime, "yyyy-MM-dd HH:mm:ss", true).toString()
        : Formatter.fullDateHourFormat(dateTime, "EEEE dd MMMM yyyy hh:mm a");
  }

  static String showDate(String? language, String? dateTime) {
    return language == "km"
        ? formatDateTime(dateTime, "yyyy-MM-dd", false).toString()
        : Formatter.fullDateHourFormat(dateTime, "EEEE dd MMMM yyyy");
  }

  static String showTime(String? language, String? time) {
    return language == "km" ? formatTime(time) : Formatter.hourFormat(time);
  }

  static String formatDateTime(String? dateTime, String _format, bool isHour) {
    final local = DateTime.parse(dateTime ?? "").toLocal();
    final format = DateFormat(_format).format(local);
    return KhmerDate.date(format,
        format: "ថ្ងៃទីdd ខែmmm ឆ្នាំyyyy ${isHour ? "hr" : ""}");
  }

  static String formatTime(String? time) {
    return KhmerDate.date("$time", format: "hr");
  }

  static String getStartMonth(DateTime month) {
    final givenMonth = Formatter.yearMonthFormat(month);
    return "$givenMonth-01 00:00:00";
  }

  static String getEndMonth(DateTime month) {
    final givenMonth = Formatter.yearMonthFormat(month);
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    return "$givenMonth-$lastDay 23:59:59";
  }

  static String getStartYear(DateTime year) {
    final selectedYear = DateTime(year.year).year;
    final firstMonth = 1;
    final firstDay = 1;
    return "$selectedYear-$firstMonth-$firstDay 00:00:00";
  }

  static String getEndYear(DateTime year) {
    final selectedYear = DateTime(year.year).year;
    final lastMonth = 12;
    final lastDay = DateTime(year.year + 1, 0, 0).day;
    return "$selectedYear-$lastMonth-$lastDay 23:59:59";
  }

  static String getStartDay(DateTime date) {
    final givenDay = Formatter.dayFormat(date);
    return givenDay + " 00:00:00";
  }

  static String getEndDay(DateTime date) {
    final tomorrow = DateTime(date.year, date.month, date.day);
    final givenTomorrow = Formatter.dayFormat(tomorrow);
    return givenTomorrow + " 23:59:59";
  }

  static getDateLocale(
    DateTime dateTime,
    TextEditingController controller,
  ) async {
    await getLanguage().then((language) {
      if (language == "en") {
        controller.text = Formatter.dateFormatWithDash(dateTime);
      } else {
        controller.text = KhmerDate.date(
          dateTime.toString(),
          format: "dd-mm-yyyy",
        );
      }
    });
  }

  static double _calculateTotalAmount(List<Entry> entries, String currency) {
    double amount = 0.0;
    entries.forEach((ledger) {
      if (ledger.entryCurrency == currency) {
        amount = amount + ledger.entryAmount!;
      }
    });
    return amount;
  }

  static double calculateGrandTotal(List<Entry> entries, String currency) {
    double total = 0.0;
    total += _calculateTotalAmount(entries, currency);
    return total;
  }

  static double grandTotalInCurrency(List<Entry> entries, String currency) {
    final exchangeRate = 4000;
    double total = 0.0;
    double grandTotalInKHR = 0.0;
    double grandTotalInUSD = 0.0;
    grandTotalInKHR += calculateGrandTotal(entries, "KHR");
    grandTotalInUSD += calculateGrandTotal(entries, "USD");
    if (currency == "KHR") {
      total += (grandTotalInUSD * exchangeRate) + grandTotalInKHR;
    } else {
      total += (grandTotalInKHR / exchangeRate) + grandTotalInUSD;
    }
    return total;
  }

  static void isEmptyDay({
    required List<DayOfWeek> dayOfWeek,
    required Function() onSuccess,
    required Function() onError,
  }) {
    bool empty = false;
    dayOfWeek.forEach((element) {
      if (element.selected == true) {
        empty = true;
        return;
      }
    });
    empty ? onSuccess.call() : onError.call();
  }
}
