import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/presentation/report/yearly/report_yearly_view_model.dart';
import 'package:expense_app/presentation/widget/custom_table.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportYearlyLedgerTableSection extends StatelessWidget {
  final ReportYearlyViewModel viewModel;

  ReportYearlyLedgerTableSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTable(
          children: viewModel.reportData.report.ledgers
              .map(
                (ledger) => TableRow(
                  children: [
                    TableRowInkWell(
                      // onTap: () => viewModel.navigateToLedgerPage(ledger),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: CustomText(
                          text: "${ledger.month}",
                          color: viewModel.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    TableRowInkWell(
                      // onTap: () => viewModel.navigateToLedgerPage(ledger),
                      child: CustomText(
                        text: "${Formatter.formatCurrency(ledger.khAmount)}៛",
                        color:
                            viewModel.isDarkMode ? Colors.white : Colors.black,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    TableRowInkWell(
                      // onTap: () => viewModel.navigateToLedgerPage(ledger),
                      child: CustomText(
                        text:
                            "${ledger.usAmount.toStringAsFixed(ledger.usAmount % 1 == 0 ? 0 : 2)}\$",
                        color:
                            viewModel.isDarkMode ? Colors.white : Colors.black,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          rielColumn: 100,
          dollaColumn: 100,
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
                    viewModel.reportData.summary.subtotalLedger.khAmount,
                  )}៛",
                  color: viewModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                ),
                CustomText(
                  text:
                      "${viewModel.reportData.summary.subtotalLedger.usAmount.toStringAsFixed(viewModel.reportData.summary.subtotalLedger.usAmount % 1 == 0 ? 0 : 2)}"
                      "\$",
                  color: viewModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
          rielColumn: 100,
          dollaColumn: 100,
        ),
      ],
    );
  }
}
