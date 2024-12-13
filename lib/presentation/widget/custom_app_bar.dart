import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(String pageTitle) {
  return AppBar(
    title: CustomText(
      text: pageTitle,
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}
