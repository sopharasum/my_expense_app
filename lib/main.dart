import 'package:expense_app/config/localization_service.dart';
import 'package:expense_app/config/theme/theme.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/home/home_page.dart';
import 'package:expense_app/presentation/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  List<String> testDeviceIds = ["F5A630043FC492C19AF602069AA37992"];
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final locale = LocalizationService().getLocaleFromLanguage(
    await getLanguage(),
  );
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  final loggedAccount = await getLoggedAccount();
  final themeMode = await ThemeService().theme;
  runApp(MyApp(locale, loggedAccount, themeMode));
}

class MyApp extends StatelessWidget {
  final Locale? locale;
  final Accountant? loggedAccountant;
  final ThemeMode themeMode;

  MyApp(this.locale, this.loggedAccountant, this.themeMode);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: Themes.light,
      darkTheme: Themes.dark,
      initialBinding: MainBinding(),
      home: loggedAccountant != null
          ? HomePage(themeMode: themeMode)
          : LoginPage(),
      themeMode: themeMode,
      locale: locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('km')],
    );
  }
}
