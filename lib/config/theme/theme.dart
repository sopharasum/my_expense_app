import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    highlightColor: Colors.grey.shade200,
    scaffoldBackgroundColor: Colors.white,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: "Siemreap",
          displayColor: Colors.black,
          bodyColor: Colors.black,
        ),
    iconTheme: ThemeData.light().iconTheme.copyWith(
          color: Colors.blue,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
      ),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    highlightColor: Colors.white.withOpacity(.1),
    scaffoldBackgroundColor: Colors.black,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: "Siemreap",
          displayColor: Colors.black,
          bodyColor: Colors.white,
        ),
    iconTheme: ThemeData.light().iconTheme.copyWith(
          color: Colors.white,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(.3),
      ),
    ),
  );
}
