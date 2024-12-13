import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/faq/faq_view_model.dart';
import 'package:expense_app/presentation/faq/widget/faq_data_section.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_empty.dart';
import 'package:expense_app/presentation/widget/entry/entry_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQPage extends StatelessWidget {
  final String language;

  FAQPage(this.language);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FAQViewModel>(
      init: FAQViewModel(context, language),
      builder: (viewModel) => Scaffold(
        appBar: customAppBar("title_drawer_faq".tr),
        body: Column(
          children: [
            viewModel.queryStatus == DataStatus.LOADING
                ? Expanded(child: EntryShimmer())
                : viewModel.queryStatus == DataStatus.EMPTY
                    ? CustomEmpty("label_faq_empty".tr)
                    : FaqDataSection(viewModel),
            CustomAdsBanner(),
          ],
        ),
      ),
    );
  }
}
