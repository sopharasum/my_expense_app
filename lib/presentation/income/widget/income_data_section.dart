import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/income/income_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/entry/entry_item.dart';
import 'package:flutter/material.dart';

class IncomeDataSection extends StatelessWidget {
  final IncomeViewModel viewModel;

  IncomeDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => viewModel.refreshData(true, reload: true),
        child: CustomScrollView(
          controller: viewModel.scroll,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ledger = viewModel.incomes[index];
                    return EntryItem(
                      ledger,
                      viewModel.isDarkMode,
                      viewModel.language,
                      (income) => viewModel.navigateToIncomeForm(income),
                      (income) => viewModel.deleteIncome(ledger),
                    );
                  },
                  childCount: viewModel.incomes.length,
                ),
              ),
            ),
            viewModel.queryStatus == DataStatus.QUERY_MORE
                ? CustomLoading()
                : CustomEmptyContainer()
          ],
        ),
      ),
    );
  }
}
