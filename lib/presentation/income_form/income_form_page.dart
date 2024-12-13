import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/presentation/income_form/income_form_view_model.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_repeat_check_box.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_text_form_field.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_toggle_buttons.dart';
import 'package:expense_app/presentation/widget/entry/form/entry_form_visibility_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IncomeFormPage extends StatefulWidget {
  final String pageTitle;
  final bool isDarkMode;
  final String language;
  final bool? isUpdate;
  final Entry? income;

  IncomeFormPage({
    required this.pageTitle,
    required this.isDarkMode,
    required this.language,
    this.isUpdate,
    this.income,
  });

  @override
  _IncomeFormPageState createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {
  bool amountError = false;
  bool categoryError = false;
  bool dateError = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    return GetBuilder<IncomeFormViewModel>(
      init: IncomeFormViewModel(context, widget.language, widget.income),
      builder: (viewModel) => WillPopScope(
        onWillPop: () async {
          viewModel.interstitialAd?.show();
          Get.back(result: viewModel.shouldRefreshData);
          return true;
        },
        child: Scaffold(
          appBar: customAppBar(widget.pageTitle),
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
                          onTap: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                currentTime: viewModel.selectedDate,
                                minTime: DateTime(2020, 5, 5, 20, 50),
                                maxTime: DateTime.now(), onConfirm: (date) {
                              viewModel.getSelectedDate(date);
                            });
                          },
                          isInteractiveSelection: false,
                          isReadOnly: true,
                          keyboardType: TextInputType.text,
                          controller: viewModel.dateController,
                          isError: dateError,
                          labelMsg: "label_date_hint".tr,
                          errorMsg: "label_date_error".tr,
                        ),
                        EntryFormTextFormField(
                          controller: viewModel.remarkController,
                          keyboardType: TextInputType.text,
                          isError: false,
                          labelMsg: "label_remark_hint".tr,
                          errorMsg: "label_remark_error".tr,
                        ),
                        Visibility(
                          visible: true,
                          child: EntryFormRepeatCheckBox(
                            label: "label_income_repeat".tr,
                            isRecurring: viewModel.isRecurring,
                            onChanged: (value) {
                              setState(() {
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                viewModel.isRecurring = value;
                              });
                            },
                          ),
                        ),
                        EntryFormVisibilityDay(
                          dayOfWeek: dayOfWeek,
                          language: viewModel.language,
                          isDarkMode: widget.isDarkMode,
                          isRecurring: viewModel.isRecurring,
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
                    viewModel.dateController.text.isEmpty
                        ? dateError = true
                        : dateError = false;
                  });
                  if (!amountError && !categoryError && !dateError) {
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    viewModel.isRecurring == true
                        ? viewModel.validateSelectedDay(
                            widget.isUpdate,
                            widget.income?.entryId,
                          )
                        : widget.isUpdate == true
                            ? viewModel.updateIncome(widget.income?.entryId)
                            : viewModel.addIncome();
                  }
                },
                child: CustomButton(widget.pageTitle, Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
