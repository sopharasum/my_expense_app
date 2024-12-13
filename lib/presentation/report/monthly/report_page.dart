import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/income/income_page.dart';
import 'package:expense_app/presentation/ledger/ledger_page.dart';
import 'package:expense_app/presentation/report/monthly/report_view_model.dart';
import 'package:expense_app/presentation/report/monthly/widget/report_income_table_section.dart';
import 'package:expense_app/presentation/report/monthly/widget/report_ledger_table_section.dart';
import 'package:expense_app/presentation/report/monthly/widget/report_summary_section.dart';
import 'package:expense_app/presentation/report/widget/report_header_section.dart';
import 'package:expense_app/presentation/report/widget/report_separator_section.dart';
import 'package:expense_app/presentation/report/widget/report_shimmer_section.dart';
import 'package:expense_app/presentation/report/yearly/report_yearly_page.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/custom_month_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  final bool ledgerReport;

  ReportPage(this.ledgerReport);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportViewModel>(
      init: ReportViewModel(context, ledgerReport),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          Get.back(result: viewModel.shouldRefreshData);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: viewModel.ledgerReport
                  ? "${"title_expense_report".tr}"
                  : "${"title_income_report".tr}",
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              CustomAction(
                widget: Icon(Icons.calendar_month_rounded),
                text: "label_report_yearly".tr,
                onTap: () => viewModel.navigateToPage(
                    ReportYearlyPage(ledgerReport: ledgerReport)),
              ),
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
                    DatePicker.showPicker(context,
                        showTitleActions: true,
                        pickerModel: CustomMonthPicker(
                          currentTime: DateTime.now(),
                          minTime: DateTime(2020, 1, 1),
                          maxTime: DateTime.now(),
                        ), onConfirm: (date) {
                      viewModel.getSelectMonth(date);
                    });
                  },
                  enableInteractiveSelection: false,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  controller: viewModel.monthController,
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
                                    headline: viewModel.ledgerReport
                                        ? "label_expense_category_hint".tr
                                        : "label_income_category_hint".tr,
                                  ),
                                  viewModel.ledgerReport
                                      ? ReportLedgerTableSection(viewModel)
                                      : ReportIncomeTableSection(viewModel),
                                  ReportSeparatorSection(),
                                  ReportSummarySection(viewModel),
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
