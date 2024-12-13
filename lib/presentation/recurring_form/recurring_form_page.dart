import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/presentation/recurring_form/recurring_form_view_model.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_text_form_field.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_toggle_buttons.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_visibility_day.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecurringFormPage extends StatefulWidget {
  final Recurring recurring;
  final String language;
  final bool isDarkMode;

  RecurringFormPage(this.recurring, this.language, this.isDarkMode);

  @override
  State<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends State<RecurringFormPage> {
  bool amountError = false;
  bool categoryError = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    return GetBuilder<RecurringFormViewModel>(
      init: RecurringFormViewModel(context, widget.language, widget.recurring),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          viewModel.interstitialAd?.show();
          return true;
        },
        child: Scaffold(
          appBar: customAppBar("title_recurring_form_page".tr),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: EntryFormTextFormField(
                                controller: viewModel.amountController,
                                keyboardType: TextInputType.number,
                                isError: amountError,
                                labelMsg: "label_total_income_hint".tr,
                                errorMsg: "label_total_income_error".tr,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    value =
                                        '${_formatNumber(value.replaceAll(',', ''))}';
                                    viewModel.amountController.value =
                                        TextEditingValue(
                                      text: value,
                                      selection: TextSelection.collapsed(
                                          offset: value.length),
                                    );
                                  }
                                },
                              ),
                            ),
                            EntryFormToggleButtons(
                              viewModel.isSelected,
                              (index) => viewModel.getSelectedCurrency(index),
                            ),
                          ],
                        ),
                        EntryFormTextFormField(
                          onTap: () => viewModel.navigateToCategory(context),
                          isInteractiveSelection: false,
                          isReadOnly: true,
                          keyboardType: TextInputType.text,
                          controller: viewModel.categoryController,
                          isError: categoryError,
                          labelMsg: "label_income_category_hint".tr,
                          errorMsg: "label_income_category_error".tr,
                        ),
                        EntryFormTextFormField(
                          controller: viewModel.remarkController,
                          keyboardType: TextInputType.text,
                          isError: false,
                          labelMsg: "label_remark_hint".tr,
                          errorMsg: "label_remark_error".tr,
                        ),
                        EntryFormTextFormField(
                          onTap: () async => viewModel.showTime(),
                          isInteractiveSelection: false,
                          isReadOnly: true,
                          keyboardType: TextInputType.text,
                          controller: viewModel.timeController,
                          isError: false,
                          labelMsg: "label_recurring_select_time".tr,
                          errorMsg: "label_recurring_select_time_error".tr,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: EntryFormVisibilityDay(
                            dayOfWeek: viewModel.recurring.dayOfWeek,
                            language: viewModel.language.toString(),
                            isDarkMode: widget.isDarkMode,
                            isRecurring: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomAdsBanner(),
              InkWell(
                onTap: () {
                  setState(() {
                    viewModel.amountController.text.isEmpty
                        ? amountError = true
                        : amountError = false;
                    viewModel.categoryController.text.isEmpty
                        ? categoryError = true
                        : categoryError = false;
                  });
                  if (!amountError && !categoryError) {
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    viewModel.validateSelectedDay(widget.recurring.recurringId);
                  }
                },
                child: CustomButton("កែប្រែកាលវិភាគ", Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
