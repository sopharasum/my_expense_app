import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/entry/entry_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HomeIncomeDataSection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeIncomeDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final income = viewModel.incomes[index];
            return EntryItem(
              income,
              viewModel.isDarkMode,
              "${viewModel.selectedLanguage}",
              (income) => viewModel.navigateToIncomeForm(income: income),
              (income) => viewModel.deleteEntry(income, false),
            );
          },
          childCount: viewModel.incomes.length,
        ),
      ),
    );
  }
}
