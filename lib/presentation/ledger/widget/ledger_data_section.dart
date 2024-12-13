import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/ledger/ledger_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/entry/entry_item.dart';
import 'package:flutter/material.dart';

class LedgerDataSection extends StatelessWidget {
  final LedgerViewModel viewModel;

  LedgerDataSection(this.viewModel);

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
                    final ledger = viewModel.ledgers[index];
                    return EntryItem(
                      ledger,
                      viewModel.isDarkMode,
                      viewModel.language,
                      (ledger) => viewModel.navigateToLedgerForm(ledger),
                      (ledger) => viewModel.deleteLedger(ledger),
                    );
                  },
                  childCount: viewModel.ledgers.length,
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
