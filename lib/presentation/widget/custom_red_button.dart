import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;

  CustomButton(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(12),
      color: color,
      child: CustomText(
        text: label,
        color: Colors.white,
        textAlign: TextAlign.center,
        fontSize: 16,
      ),
    );
  }
}
