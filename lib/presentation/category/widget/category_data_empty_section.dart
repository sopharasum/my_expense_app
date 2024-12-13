import 'package:expense_app/presentation/category/category_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDataEmptySection extends StatelessWidget {
  final CategoryViewModel viewModel;
  final String? type;

  CategoryDataEmptySection(this.viewModel, this.type);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        alignment: Alignment.center,
        child: CustomText(
          text: type == "ledger"
              ? "${"label_expense_category_list_empty".tr}"
              : "${"label_income_category_list_empty".tr}",
          textAlign: TextAlign.center,
          fontSize: 18,
          color: viewModel.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
