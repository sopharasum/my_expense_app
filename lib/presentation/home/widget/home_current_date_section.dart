import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCurrentDateSection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeCurrentDateSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            CustomText(
              text: viewModel.ledgerOperation
                  ? "${"label_total_expense_of".tr}"
                  : "${"label_total_income_of".tr}",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            CustomText(
              text: viewModel.currentDate.toString(),
              textAlign: TextAlign.center,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
