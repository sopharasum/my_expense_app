import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/presentation/report/monthly/report_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportSummarySection extends StatelessWidget {
  final ReportViewModel viewModel;

  ReportSummarySection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText("${"label_total_expense".tr}", fontSize: 15),
        _buildRow(
            label: "label_in_khmer_riel".tr,
            value: "${Formatter.formatCurrency(
              viewModel.reportData.summary.totalLedger.khAmount,
            )}៛",
            showBorder: true),
        _buildRow(
          label: "label_in_us_dollar".tr,
          value:
              "${viewModel.reportData.summary.totalLedger.usAmount.toStringAsFixed(viewModel.reportData.summary.totalLedger.usAmount % 1 == 0 ? 0 : 2)}\$",
        ),
        _buildText("label_total_income".tr, fontSize: 15),
        _buildRow(
          label: "label_in_khmer_riel".tr,
          value: "${Formatter.formatCurrency(
            viewModel.reportData.summary.totalIncome.khAmount,
          )}៛",
          showBorder: true,
        ),
        _buildRow(
          label: "label_in_us_dollar".tr,
          value:
              "${viewModel.reportData.summary.totalIncome.usAmount.toStringAsFixed(viewModel.reportData.summary.totalIncome.usAmount % 1 == 0 ? 0 : 2)}\$",
        ),
        _buildText("label_different".tr, fontSize: 15),
        _buildRow(
          label: "label_in_khmer_riel".tr,
          value: "${Formatter.formatCurrency(
            viewModel.reportData.summary.balance.khAmount,
          )}៛",
          color: viewModel.reportData.summary.balance.khAmount.isNegative
              ? Colors.red
              : Colors.blue,
          showBorder: true,
        ),
        _buildRow(
          label: "label_in_us_dollar".tr,
          value:
              "${viewModel.reportData.summary.balance.usAmount.toStringAsFixed(viewModel.reportData.summary.balance.usAmount % 1 == 0 ? 0 : 2)}\$",
          color: viewModel.reportData.summary.balance.usAmount.isNegative
              ? Colors.red
              : Colors.blue,
        ),
      ],
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    Color? color,
    bool? showBorder,
  }) {
    return Column(
      children: [
        if (showBorder != null)
          Divider(
            height: 1,
            color: viewModel.isDarkMode ? Colors.white : Colors.grey,
          ),
        Row(
          children: [
            _buildText(label),
            Expanded(
              child: CustomText(
                text: value,
                color: color != null
                    ? color
                    : viewModel.isDarkMode
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
          color: viewModel.isDarkMode ? Colors.white : Colors.grey,
        )
      ],
    );
  }

  Widget _buildText(String title, {double? fontSize}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
        color: fontSize == null
            ? viewModel.isDarkMode
                ? Colors.white
                : Colors.black
            : Colors.red,
        fontSize: fontSize == null ? 14 : fontSize,
      ),
    );
  }
}
