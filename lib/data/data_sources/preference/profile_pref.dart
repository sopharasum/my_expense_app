import 'dart:convert';

import 'package:expense_app/domain/entities/accountant.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefLoggedAccountant = "LoggedAccountant";

Future<void> saveAccountant(Accountant accountant) async {
  String jsonAccountant = jsonEncode(accountant.toJson());
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(prefLoggedAccountant, jsonAccountant);
}

Future<Accountant?> getLoggedAccount() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var accountantString = pref.getString(prefLoggedAccountant) ?? null;
  if (accountantString != null) {
    Map<String, dynamic> json = jsonDecode(accountantString.toString());
    return Accountant.fromJson(json);
  } else {
    return null;
  }
}

Future<void> removeLoggedAccountant() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove(prefLoggedAccountant);
}
