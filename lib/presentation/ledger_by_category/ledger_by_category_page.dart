import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:expense_app/presentation/ledger_by_category/ledger_by_category_view_model.dart';
import 'package:expense_app/presentation/ledger_by_category/widget/ledger_by_category_data_section.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_empty.dart';
import 'package:expense_app/presentation/widget/entry/entry_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LedgerByCategoryPage extends StatelessWidget {
  final ReportCategory category;
  final DateTime selectedMonth;

  LedgerByCategoryPage(this.category, this.selectedMonth);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerByCategoryViewModel>(
      init: LedgerByCategoryViewModel(context, category, selectedMonth),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          Get.back(result: viewModel.shouldRefreshData);
          return true;
        },
        child: Scaffold(
          appBar: customAppBar("${category.name}"),
          body: Column(
            children: [
              viewModel.queryStatus == DataStatus.LOADING
                  ? Expanded(child: EntryShimmer())
                  : viewModel.queryStatus == DataStatus.EMPTY
                      ? CustomEmpty("label_expense_list_empty".tr)
                      : LedgerByCategoryDataSection(viewModel),
              CustomAdsBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
