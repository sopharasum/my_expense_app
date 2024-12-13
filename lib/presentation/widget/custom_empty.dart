import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomEmpty extends StatelessWidget {
  final String message;

  CustomEmpty(this.message);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: CustomText(
          text: message,
          textAlign: TextAlign.center,
          fontSize: 18,
        ),
      ),
    );
  }
}
