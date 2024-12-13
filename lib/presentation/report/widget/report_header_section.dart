import 'package:expense_app/presentation/widget/custom_table.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportHeaderSection extends StatelessWidget {
  final String headline;
  final double? rielColumn;
  final double? dollarColumn;

  const ReportHeaderSection({
    Key? key,
    required this.headline,
    this.rielColumn,
    this.dollarColumn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      children: [
        TableRow(
          children: [
            CustomText(
              text: headline,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            CustomText(
              text: "label_total_as_riel".tr,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              textAlign: TextAlign.end,
            ),
            CustomText(
              text: "label_total_as_usd".tr,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              textAlign: TextAlign.end,
            ),
          ],
        )
      ],
      rielColumn: rielColumn,
      dollaColumn: dollarColumn,
    );
  }
}
