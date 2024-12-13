import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/usecases/recurring/recurring_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/category/category_page.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class RecurringFormViewModel extends GetxController {
  final BuildContext context;
  final String language;
  final Recurring recurring;
  final RecurringUseCases _recurringUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  List<bool> isSelected = [true, false];
  List<String> currencies = ["KHR", "USD"];
  String currency = "KHR";

  InterstitialAd? interstitialAd;
  Category? category;

  RecurringFormViewModel(this.context, this.language, this.recurring);

  @override
  void onInit() {
    isSelected = [
      recurring.recurringCurrency == "KHR",
      recurring.recurringCurrency == "USD"
    ];
    _getRecurringInfo();
    showInterstitialAd(
      isShow: false,
      onAdLoaded: (value) => interstitialAd = value,
    );
    super.onInit();
  }

  void _getRecurringInfo() {
    amountController.text = _formatCurrency(recurring);
    categoryController.text = "${recurring.category?.categoryName}";
    remarkController.text = "${recurring.recurringRemark}";
    timeController.text = "${recurring.recurringTime}";
    recurring.recurringCurrency == "KHR"
        ? getSelectedCurrency(0)
        : getSelectedCurrency(1);
    update();
  }

  String _formatCurrency(Recurring recurring) {
    if (recurring.recurringCurrency == "KHR") {
      return Formatter.formatCurrency(recurring.recurringAmount);
    } else {
      return "${recurring.recurringAmount}";
    }
  }

  void getSelectedCurrency(int index) {
    this.currency = currencies[index];
  }

  void navigateToCategory(BuildContext context) async {
    Get.to(() => CategoryPage(language: language), binding: MainBinding())
        ?.then((category) {
      if (category != null) {
        this.category = category;
        categoryController.text = "${this.category?.categoryName}";
      }
    });
  }

  void validateSelectedDay(int? id) {
    _loading.show();
    EntryUtil.isEmptyDay(
      dayOfWeek: this.recurring.dayOfWeek,
      onSuccess: () => updateRecurring(id),
      onError: () {
        _loading.hide();
        SnackBarUtil.showSnackBar(context, "msg_day_empty_error".tr);
        return;
      },
    );
  }

  void updateRecurring(int? id) async {
    final recurring = Recurring(
      recurringId: id,
      category: category ?? this.recurring.category,
      recurringAmount: double.parse(amountController.text.replaceAll(",", "")),
      recurringCurrency: currency,
      recurringRemark: remarkController.text,
      recurringDate: this.recurring.recurringDate,
      recurringTime: DateFormat("HH:mm:ss").format(
        DateTime.parse(
            "${this.recurring.recurringDate} ${timeController.text}"),
      ),
      dayOfWeek: this.recurring.dayOfWeek,
      recurringCreatedDate: this.recurring.recurringCreatedDate,
    );
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () async {
        try {
          await _recurringUseCases.updateUseCase
              .update(recurring)
              .then((message) {
            _loading.hide();
            SnackBarUtil.showSnackBar(context, message);
            Get.back(result: recurring);
          });
        } on ApiError catch (error) {
          switch (error.apiErrorType) {
            case ApiErrorType.NO_INTERNET:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, "No Internet Connection");
              break;
            case ApiErrorType.EXPIRE_TOKEN:
              this.updateRecurring(id);
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

  void showTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: convertTime(),
    );
    if (selectedTime != null && selectedTime != convertTime()) {
      final time = DateFormat("HH:mm:ss")
          .parse("${selectedTime.hour}:${selectedTime.minute}:00");
      timeController.text = DateFormat("HH:mm:ss").format(time);
      update();
    }
  }

  TimeOfDay convertTime() {
    return TimeOfDay(
        hour: int.parse(recurring.recurringTime.split(":")[0]),
        minute: int.parse(recurring.recurringTime.split(":")[1]));
  }

  @override
  void onClose() {
    amountController.dispose();
    categoryController.dispose();
    remarkController.dispose();
    timeController.dispose();
    interstitialAd?.dispose();
    super.onClose();
  }
}
