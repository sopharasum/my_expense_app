import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/presentation/report/monthly/report_view_model.dart';
import 'package:expense_app/presentation/widget/custom_table.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportIncomeTableSection extends StatelessWidget {
  final ReportViewModel viewModel;

  ReportIncomeTableSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTable(
          children: viewModel.reportData.report.incomes
              .map(
                (income) => TableRow(
                  children: [
                    TableRowInkWell(
                      onTap: () => viewModel.navigateToIncomePage(income),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: CustomText(
                          text: "${income.name}",
                          color: viewModel.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    TableRowInkWell(
                      onTap: () => viewModel.navigateToIncomePage(income),
                      child: CustomText(
                        text: "${Formatter.formatCurrency(income.khAmount)}៛",
                        color: viewModel.isDarkMode ? Colors.white : Colors.black,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    TableRowInkWell(
                      onTap: () => viewModel.navigateToIncomePage(income),
                      child: CustomText(
                        text:
                            "${income.usAmount.toStringAsFixed(income.usAmount % 1 == 0 ? 0 : 2)}\$",
                        color: viewModel.isDarkMode ? Colors.white : Colors.black,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
        MySeparator(color: viewModel.isDarkMode ? Colors.white : Colors.grey),
        CustomTable(
          children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CustomText(
                    text: "${"label_sub_total".tr}",
                    color: viewModel.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomText(
                  text: "${Formatter.formatCurrency(
                    viewModel.reportData.summary.subtotalIncome.khAmount,
                  )}៛",
                  color: viewModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                ),
                CustomText(
                  text:
                      "${viewModel.reportData.summary.subtotalIncome.usAmount.toStringAsFixed(viewModel.reportData.summary.subtotalIncome.usAmount % 1 == 0 ? 0 : 2)}\$",
                  color: viewModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
