import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  final _key = "SelectedTheme";

  Future<ThemeMode> get theme async {
    final value = await loadThemeFromPref();
    return value ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveThemeToPref(bool isDarkMode) async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setBool(_key, isDarkMode);
  }

  Future<bool> loadThemeFromPref() async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.getBool(_key) ?? false;
  }

  void switchTheme() {
    loadThemeFromPref().then((value) {
      Get.changeThemeMode(value ? ThemeMode.light : ThemeMode.dark);
      _saveThemeToPref(!value);
    });
  }
}
