import 'dart:ui';

import 'package:expense_app/config/lang/en_us.dart';
import 'package:expense_app/config/lang/km_kh.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('km', 'KH');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'en',
    'km',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('km', 'KH'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS, // lang/en_us.dart
        'km_KH': kmKH, // lang/km_kh.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}
