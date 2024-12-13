import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/entry/entry_item.dart';
import 'package:flutter/material.dart';

class HomeLedgerDataSection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeLedgerDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final ledger = viewModel.ledgers[index];
            return EntryItem(
              ledger,
              viewModel.isDarkMode,
              "${viewModel.selectedLanguage}",
              (ledger) => viewModel.navigateToLedgerForm(ledger: ledger),
              (ledger) => viewModel.deleteEntry(ledger, true),
            );
          },
          childCount: viewModel.ledgers.length,
        ),
      ),
    );
  }
}
