import 'package:shared_preferences/shared_preferences.dart';

const String prefUserGuide = "UserGuide";

Future<void> setGuided(bool guided) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setBool(prefUserGuide, guided);
}

Future<bool> getGuided() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getBool(prefUserGuide) ?? false;
}