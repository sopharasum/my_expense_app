import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDataEmptySection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeDataEmptySection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        alignment: Alignment.center,
        child: CustomText(
          text: viewModel.ledgerOperation
              ? "${"label_expense_list_empty".tr}"
              : "${"label_income_list_empty".tr}",
          textAlign: TextAlign.center,
          fontSize: 18,
        ),
      ),
    );
  }
}
