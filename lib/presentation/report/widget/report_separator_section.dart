import 'package:expense_app/util/my_separator.dart';
import 'package:flutter/material.dart';

class ReportSeparatorSection extends StatelessWidget {
  const ReportSeparatorSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: MySeparator(height: 5, color: Colors.blue.shade300),
    );
  }
}
