import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final double height;
  final FontWeight? fontWeight;

  CustomText({
    this.text = '',
    this.fontSize = 14.0,
    this.color,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.height = 1,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        color: color ?? color,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
    );
  }
}
