import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAction extends StatelessWidget {
  final double? padding;
  final Widget widget;
  final String text;
  final Function() onTap;

  CustomAction({
    this.padding,
    required this.widget,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget,
            CustomText(text: text, fontSize: 8, color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
