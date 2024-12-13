import 'package:expense_app/presentation/donate/donate_view_model.dart';
import 'package:expense_app/presentation/donate/widget/plan_item.dart';
import 'package:flutter/material.dart';

class DonateDataSection extends StatelessWidget {
  final DonateViewModel viewModel;

  DonateDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => PlanItem(viewModel, viewModel.plans[index]),
        childCount: viewModel.plans.length,
      ),
    );
  }
}
