import 'package:shared_preferences/shared_preferences.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<void> setLanguage(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
}

Future<String> getLanguage() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var language = _prefs.getString(prefSelectedLanguageCode) ?? "km";
  return language;
}
