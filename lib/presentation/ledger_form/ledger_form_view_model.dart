import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/extension.dart';
import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/usecases/ledger/ledger_use_cases.dart';
import 'package:expense_app/domain/usecases/recurring/recurring_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/category/category_page.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class LedgerFormViewModel extends GetxController {
  final BuildContext context;
  final String language;
  final Entry? ledger;
  final LedgerUseCases _ledgerUseCases = Get.find();
  final RecurringUseCases _recurringUseCases = Get.find();
  final MaterialLoading _loading = Get.find();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  List<bool> isSelected = [true, false];
  InterstitialAd? interstitialAd;
  FacebookInterstitialAd? facebookInterstitialAd;

  DateTime selectedDate = DateTime.now();
  Category? category;
  List<String> currencies = ["KHR", "USD"];
  String currency = "KHR";
  bool? isRecurring = false;
  bool shouldRefreshData = false;

  LedgerFormViewModel(this.context, this.language, this.ledger);

  @override
  void onInit() async {
    _getCurrentDay();
    if (ledger != null) {
      isSelected = [
        ledger?.entryCurrency == "KHR",
        ledger?.entryCurrency == "USD"
      ];
    }
    showInterstitialAd(
      isShow: false,
      onAdLoaded: (value) => interstitialAd = value,
    );
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: "get_ledger => ${ledger?.entryRemark}");
    if (ledger != null) {
      amountController.text = _formatCurrency(ledger);
      categoryController.text = "${ledger?.entryCategory?.categoryName}";
      getSelectedDate(DateTime.parse("${ledger?.entryDateTime}"));
      remarkController.text = "${ledger?.entryRemark}";
      ledger?.entryCurrency == "KHR"
          ? getSelectedCurrency(0)
          : getSelectedCurrency(1);
    } else {
      getSelectedDate(selectedDate);
    }
    super.onReady();
  }

  String _formatCurrency(Entry? ledger) {
    if (ledger?.entryCurrency == "KHR") {
      return Formatter.formatCurrency(ledger?.entryAmount);
    } else {
      return "${ledger?.entryAmount}";
    }
  }

  void getSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    if (DateTime.now().isSameDate(dateTime)) {
      dateController.text = "label_date_today".tr;
    } else {
      EntryUtil.getDateLocale(dateTime, dateController);
    }
    _getCurrentDay();
    update();
  }

  void getSelectedCurrency(int index) {
    this.currency = currencies[index];
  }

  void navigateToCategory(BuildContext context) async {
    Get.to(
      () => CategoryPage(
        type: "ledger",
        language: language,
      ),
      binding: MainBinding(),
    )?.then((category) {
      if (category != null) {
        this.category = category;
        categoryController.text = "${this.category?.categoryName}";
      }
    });
  }

  void addLedger() async {
    _loading.show();
    final ledger = Entry(
      entryCategory: category,
      entryAmount: double.parse(amountController.text.replaceAll(",", "")),
      entryCurrency: currency,
      entryDateTime: Formatter.dateToString(selectedDate),
      entryRemark: remarkController.text,
    );
    try {
      await _ledgerUseCases.addUseCase.add(ledger).then((message) {
        amountController.clear();
        categoryController.clear();
        remarkController.clear();
        shouldRefreshData = true;
        isRecurring = false;
        _loading.hide();
        SnackBarUtil.showSnackBar(context, message);
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this.addLedger();
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void updateLedger(int? ledgerId) async {
    _loading.show();
    final ledger = Entry(
      entryId: ledgerId,
      entryCategory: category ?? this.ledger?.entryCategory,
      entryAmount: double.parse(amountController.text.replaceAll(",", "")),
      entryCurrency: currency,
      entryDateTime:
          selectedDate == DateTime.parse("${this.ledger?.entryDateTime}")
              ? null
              : Formatter.dateToString(selectedDate),
      entryRemark: remarkController.text,
    );
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () async {
        try {
          await _ledgerUseCases.updateUseCase.update(ledger).then((message) {
            shouldRefreshData = true;
            isRecurring = false;
            _loading.hide();
            SnackBarUtil.showSnackBar(context, message);
            update();
          });
          Get.back(result: shouldRefreshData);
        } on ApiError catch (error) {
          switch (error.apiErrorType) {
            case ApiErrorType.NO_INTERNET:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, "No Internet Connection");
              break;
            case ApiErrorType.EXPIRE_TOKEN:
              this.updateLedger(ledgerId);
              break;
            case ApiErrorType.ERROR_REQUEST:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
              break;
          }
        }
      },
    );
  }

  void validateSelectedDay(bool? isUpdate, int? ledgerId) {
    _loading.show();
    EntryUtil.isEmptyDay(
      dayOfWeek: dayOfWeek,
      onSuccess: () => addRecurring(isUpdate, ledgerId),
      onError: () {
        _loading.hide();
        SnackBarUtil.showSnackBar(context, "msg_day_empty_error".tr);
        return;
      },
    );
  }

  void addRecurring(bool? isUpdate, int? ledgerId) async {
    final recurring = Recurring(
      category: category ?? this.ledger?.entryCategory,
      recurringAmount: double.parse(amountController.text.replaceAll(",", "")),
      recurringCurrency: currency,
      recurringRemark: remarkController.text,
      recurringTime: DateFormat("HH:mm:ss").format(ledger == null
          ? selectedDate
          : DateTime.parse("${ledger?.entryDateTime}").toLocal()),
      dayOfWeek: dayOfWeek,
    );
    try {
      await _recurringUseCases.addUseCase.add(recurring).then(
          (value) => isUpdate == true ? updateLedger(ledgerId) : addLedger());
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          return;
        case ApiErrorType.EXPIRE_TOKEN:
          this.addRecurring(isUpdate, ledgerId);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          return;
      }
    }
  }

  void _getCurrentDay() {
    dayOfWeek.forEach((element) {
      element.selected = element.en == DateTime.now().currentDay(selectedDate);
    });
  }

  @override
  void onClose() {
    interstitialAd?.dispose();
    amountController.dispose();
    categoryController.dispose();
    dateController.dispose();
    remarkController.dispose();
    interstitialAd?.dispose();
    super.onClose();
  }
}
