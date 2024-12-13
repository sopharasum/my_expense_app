import 'dart:convert';

import 'package:expense_app/domain/entities/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefPaymentStatus = "PaymentStatus";

Future<void> setPayment(Payment payment) async {
  String jsonPayment = jsonEncode(payment.toJson());
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefPaymentStatus, jsonPayment);
}

Future<Payment?> getPayment() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var paymentString = _prefs.getString(prefPaymentStatus) ?? null;
  if (paymentString != null) {
    Map<String, dynamic> json = jsonDecode(paymentString.toString());
    return Payment.fromJson(json);
  } else {
    return null;
  }
}

Future<void> removePayment() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove(prefPaymentStatus);
}
