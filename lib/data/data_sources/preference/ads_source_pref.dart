import 'package:expense_app/config/constance.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefAdsSource = "AdsSource";

Future<void> setAdsSource(String adsSource) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefAdsSource, adsSource);
}

Future<String> getAdsSource() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString(prefAdsSource) ?? AdsSource.FACEBOOK.name;
}
