import 'package:shared_preferences/shared_preferences.dart';

const String prefSelectedDate = "SelectedDate";

Future<void> setDate(DateTime dateTime) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedDate, dateTime.toIso8601String());
}

Future<String?> getDate() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var date = _prefs.getString(prefSelectedDate) ?? null;
  return date;
}

Future<void> removeDate() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove(prefSelectedDate);
}
