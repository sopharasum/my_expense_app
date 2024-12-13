import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/donate/donate_view_model.dart';
import 'package:expense_app/presentation/donate/widget/donate_data_section.dart';
import 'package:expense_app/presentation/donate/widget/donate_shimmer_section.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonateViewModel>(
      init: DonateViewModel(context),
      builder: (viewModel) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "title_drawer_donate".tr,
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top: 12),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "title_remove_ads".tr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    sliver: viewModel.queryStatus == DataStatus.LOADING
                        ? DonateShimmerSection(viewModel)
                        : DonateDataSection(viewModel),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: CustomText(
                        text: "msg_subscribe_benefit".tr,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      top: 4,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: CustomText(
                        text: "msg_ads_notice".tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomAdsBanner(),
          ],
        ),
      ),
    );
  }
}
