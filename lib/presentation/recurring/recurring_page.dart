import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/recurring/recurring_view_model.dart';
import 'package:expense_app/presentation/recurring/widget/recurring_data_section.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_empty.dart';
import 'package:expense_app/presentation/widget/entry/entry_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecurringPage extends StatelessWidget {
  final bool isDarkMode;

  RecurringPage(this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecurringViewModel>(
      init: RecurringViewModel(context, isDarkMode),
      builder: (viewModel) => Scaffold(
        appBar: customAppBar("title_drawer_recurring".tr),
        body: Column(
          children: [
            viewModel.queryStatus == DataStatus.LOADING
                ? Expanded(child: EntryShimmer())
                : viewModel.queryStatus == DataStatus.EMPTY ||
                        viewModel.recurrences.isEmpty
                    ? CustomEmpty("label_recurring_empty".tr)
                    : RecurringDataSection(viewModel),
            CustomAdsBanner(),
          ],
        ),
      ),
    );
  }
}
