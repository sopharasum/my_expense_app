import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/transaction/transaction_view_model.dart';
import 'package:expense_app/presentation/transaction/widget/transaction_data_section.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_empty.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/presentation/widget/entry/entry_shimmer.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionViewModel>(
      init: TransactionViewModel(context),
      builder: (viewModel) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "title_drawer_transaction".tr,
            color: Colors.white,
            fontSize: 18,
          ),
          actions: [
            CustomAction(
              widget: Icon(Icons.info_outline_rounded),
              text: "label_contact_us".tr,
              onTap: () => AppDialog().showPayment(context),
            )
          ],
        ),
        body: Column(
          children: [
            viewModel.queryStatus == DataStatus.LOADING
                ? Expanded(child: EntryShimmer())
                : viewModel.queryStatus == DataStatus.EMPTY
                    ? CustomEmpty("label_transaction_empty".tr)
                    : TransactionDataSection(viewModel),
            CustomAdsBanner(),
          ],
        ),
      ),
    );
  }
}
