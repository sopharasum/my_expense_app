import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/ledger/ledger_view_model.dart';
import 'package:expense_app/presentation/ledger/widget/ledger_data_section.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_empty.dart';
import 'package:expense_app/presentation/widget/entry/entry_category_selector.dart';
import 'package:expense_app/presentation/widget/entry/entry_date_selector.dart';
import 'package:expense_app/presentation/widget/entry/entry_reset_filter_button.dart';
import 'package:expense_app/presentation/widget/entry/entry_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LedgerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerViewModel>(
      init: LedgerViewModel(context),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          Get.back(result: viewModel.shouldRefreshData);
          return true;
        },
        child: Scaffold(
          appBar: customAppBar("${"title_all_expense".tr}"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EntryDateSelector(
                      viewModel.dateController,
                      "label_date_hint".tr,
                      (dateRange) => viewModel.getSelectedDateRange(dateRange),
                    ),
                    SizedBox(width: 12),
                    EntryCategorySelector(
                      viewModel.categories,
                      viewModel.categoryController,
                      "ledger",
                      "label_expense_category_error".tr,
                      "title_expense_category".tr,
                      (category) => viewModel.selectedCategory(category),
                    ),
                  ],
                ),
              ),
              viewModel.queryStatus == DataStatus.LOADING
                  ? Expanded(child: EntryShimmer())
                  : viewModel.queryStatus == DataStatus.EMPTY
                      ? CustomEmpty("label_expense_list_empty".tr)
                      : LedgerDataSection(viewModel),
              CustomAdsBanner(),
              EntryResetFilterButton(
                viewModel.isFiltering,
                () => viewModel.resetFilter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
