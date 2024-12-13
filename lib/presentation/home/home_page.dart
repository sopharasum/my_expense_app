import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/home/widget/home_action_section.dart';
import 'package:expense_app/presentation/home/widget/home_current_date_section.dart';
import 'package:expense_app/presentation/home/widget/home_data_empty_section.dart';
import 'package:expense_app/presentation/home/widget/home_drawer_section.dart';
import 'package:expense_app/presentation/home/widget/home_income_data_section.dart';
import 'package:expense_app/presentation/home/widget/home_ledger_data_section.dart';
import 'package:expense_app/presentation/home/widget/home_shimmer_section.dart';
import 'package:expense_app/presentation/home/widget/home_summary_section.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ThemeMode themeMode;
  final bool? isFromLogin;

  HomePage({required this.themeMode, this.isFromLogin});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(
        context: context,
        themeMode: themeMode,
        isFromLogin: isFromLogin,
      ),
      builder: (viewModel) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: viewModel.ledgerOperation
                ? "${"title_expense_entry".tr}"
                : "${"title_income_entry".tr}",
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          actions: [HomeActionSection(viewModel)],
        ),
        drawer: homeDrawer(context, viewModel),
        body: Column(
          children: [
            viewModel.queryStatus == DataStatus.LOADING
                ? Expanded(child: HomeShimmerSection())
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => viewModel.shouldRefreshPage(true),
                      child: CustomScrollView(
                        controller: viewModel.scroll,
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                          HomeCurrentDateSection(viewModel),
                          HomeSummarySection(viewModel),
                          SliverToBoxAdapter(
                            child: CustomText(
                              text: viewModel.ledgerOperation
                                  ? "${"label_expense_list".tr}"
                                  : "${"label_income_list".tr}",
                              textAlign: TextAlign.center,
                              color: viewModel.isDarkMode
                                  ? Colors.white
                                  : Colors.red.shade300,
                              fontSize: 16,
                            ),
                          ),
                          viewModel.ledgerOperation
                              ? viewModel.ledgerStatus == DataStatus.EMPTY
                                  ? HomeDataEmptySection(viewModel)
                                  : HomeLedgerDataSection(viewModel)
                              : viewModel.incomeStatus == DataStatus.EMPTY
                                  ? HomeDataEmptySection(viewModel)
                                  : HomeIncomeDataSection(viewModel),
                          viewModel.queryMoreStatus == DataStatus.QUERY_MORE
                              ? CustomLoading()
                              : CustomEmptyContainer()
                        ],
                      ),
                    ),
                  ),
            // CustomFBBannerAds(),
            CustomAdsBanner(),
            InkWell(
              onTap: () => viewModel.navigateToReportPage(),
              child: CustomButton("button_view_report".tr, Colors.red),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.addNewRecord(),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
