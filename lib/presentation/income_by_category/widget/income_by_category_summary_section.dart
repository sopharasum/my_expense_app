import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/presentation/income_by_category/income_by_category_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomeByCategorySummarySection extends StatelessWidget {
  final IncomeByCategoryViewModel viewModel;

  IncomeByCategorySummarySection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: Offset(0, 0),
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "${"label_total_as".tr}",
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              CustomText(
                text: "${"label_total_as_riel".tr} ${Formatter.formatCurrency(
                  viewModel.grandTotalInCurrency(
                    "KHR",
                  ),
                )}",
                fontWeight: FontWeight.bold,
                fontSize: 13,
                textAlign: TextAlign.right,
              ),
              CustomText(
                text:
                    "${"label_total_as_usd".tr} ${viewModel.grandTotalInCurrency(
                          "USD",
                        ).toStringAsFixed(viewModel.grandTotalInCurrency(
                              "USD",
                            ) % 1 == 0 ? 0 : 2)}",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
