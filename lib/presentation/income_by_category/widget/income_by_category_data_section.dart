import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/income_by_category/income_by_category_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/entry/entry_item.dart';
import 'package:flutter/material.dart';

class IncomeByCategoryDataSection extends StatelessWidget {
  final IncomeByCategoryViewModel viewModel;

  IncomeByCategoryDataSection(this.viewModel);

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
                    return EntryItem(
                      viewModel.incomes[index],
                      viewModel.isDarkMode,
                      viewModel.language,
                      (income) => viewModel.navigateToIncomeForm(income),
                      (income) => viewModel.deleteIncome(income.entryId),
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
