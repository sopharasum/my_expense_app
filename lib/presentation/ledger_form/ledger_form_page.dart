import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/presentation/ledger_form/ledger_form_view_model.dart';
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

class LedgerFormPage extends StatefulWidget {
  final String pageTitle;
  final bool isDarkMode;
  final String language;
  final bool? isUpdate;
  final Entry? ledger;

  LedgerFormPage({
    required this.pageTitle,
    required this.isDarkMode,
    required this.language,
    this.isUpdate,
    this.ledger,
  });

  @override
  _LedgerFormPageState createState() => _LedgerFormPageState();
}

class _LedgerFormPageState extends State<LedgerFormPage> {
  bool amountError = false;
  bool categoryError = false;
  bool dateError = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    return GetBuilder<LedgerFormViewModel>(
      init: LedgerFormViewModel(context, widget.language, widget.ledger),
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
                                labelMsg: "label_total_expense_hint".tr,
                                errorMsg: "label_total_expense_error".tr,
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
                          controller: viewModel.categoryController,
                          keyboardType: TextInputType.text,
                          isError: categoryError,
                          labelMsg: "label_expense_category_hint".tr,
                          errorMsg: "label_expense_category_error".tr,
                          isInteractiveSelection: false,
                          isReadOnly: true,
                          onTap: () => viewModel.navigateToCategory(context),
                        ),
                        EntryFormTextFormField(
                          controller: viewModel.dateController,
                          keyboardType: TextInputType.text,
                          isError: dateError,
                          labelMsg: "label_date_hint".tr,
                          errorMsg: "label_date_error".tr,
                          isInteractiveSelection: false,
                          isReadOnly: true,
                          onTap: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                currentTime: viewModel.selectedDate,
                                minTime: DateTime(2020, 5, 5, 20, 50),
                                maxTime: DateTime.now(), onConfirm: (date) {
                              viewModel.getSelectedDate(date);
                            });
                          },
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
                            label: "label_expense_repeat".tr,
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
                            widget.ledger?.entryId,
                          )
                        : widget.isUpdate == true
                            ? viewModel.updateLedger(widget.ledger?.entryId)
                            : viewModel.addLedger();
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
