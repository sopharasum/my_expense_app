import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/income/income_page.dart';
import 'package:expense_app/presentation/ledger/ledger_page.dart';
import 'package:expense_app/presentation/report/widget/report_header_section.dart';
import 'package:expense_app/presentation/report/widget/report_separator_section.dart';
import 'package:expense_app/presentation/report/widget/report_shimmer_section.dart';
import 'package:expense_app/presentation/report/yearly/report_yearly_view_model.dart';
import 'package:expense_app/presentation/report/yearly/widget/report_yearly_income_table_section.dart';
import 'package:expense_app/presentation/report/yearly/widget/report_yearly_ledger_table_section.dart';
import 'package:expense_app/presentation/report/yearly/widget/report_yearly_summary_section.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportYearlyPage extends StatelessWidget {
  final bool ledgerReport;

  const ReportYearlyPage({
    Key? key,
    required this.ledgerReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportYearlyViewModel>(
      init: ReportYearlyViewModel(context, ledgerReport),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          Get.back(result: viewModel.shouldRefreshData);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: viewModel.ledgerReport
                  ? "${"title_expense_report_yearly".tr}"
                  : "${"title_income_report_yearly".tr}",
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              CustomAction(
                widget: Icon(viewModel.ledgerReport
                    ? Icons.account_balance_wallet_rounded
                    : Icons.attach_money_rounded),
                text: viewModel.ledgerReport
                    ? "label_icon_income".tr
                    : "label_icon_expense".tr,
                onTap: () => viewModel.toggleReport(),
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: TextFormField(
                  style: TextStyle(
                    color: viewModel.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("label_select_year".tr),
                        content: Container(
                          width: 300,
                          height: 300,
                          child: YearPicker(
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime(DateTime.now().year, 1),
                            initialDate: DateTime.now(),
                            selectedDate: viewModel.selectedYear,
                            onChanged: (DateTime dateTime) {
                              Navigator.pop(context);
                              viewModel.getSelectYear(dateTime);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  enableInteractiveSelection: false,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  controller: viewModel.yearController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "${"select_date_error".tr}",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      prefixIcon: Icon(Icons.calendar_month_rounded)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: viewModel.queryStatus == DataStatus.LOADING
                          ? ReportShimmerSection()
                          : SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ReportHeaderSection(
                                    headline: "label_report_monthly".tr,
                                    rielColumn: 100,
                                    dollarColumn: 100,
                                  ),
                                  viewModel.ledgerReport
                                      ? ReportYearlyLedgerTableSection(
                                          viewModel)
                                      : ReportYearlyIncomeTableSection(
                                          viewModel),
                                  ReportSeparatorSection(),
                                  ReportYearlySummarySection(viewModel),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              CustomAdsBanner(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => viewModel.ledgerReport
                          ? viewModel.navigateToPage(LedgerPage())
                          : viewModel.navigateToPage(IncomePage()),
                      child: CustomButton(
                        viewModel.ledgerReport
                            ? "${"button_view_all_expense".tr}"
                            : "${"button_view_all_income".tr}",
                        Colors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => viewModel.showExportType(),
                      child: CustomButton(
                        "button_export_report".tr,
                        Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
