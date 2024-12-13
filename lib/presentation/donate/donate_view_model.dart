import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/usecases/payment/payment_use_cases.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonateViewModel extends GetxController {
  final BuildContext context;
  final PaymentUseCases _paymentUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();

  DataStatus queryStatus = DataStatus.LOADING;
  List<Plan> plans = [];

  int _page = 0;
  bool isEnableQueryMore = false;
  bool isDarkMode = false;

  DonateViewModel(this.context);

  @override
  void onInit() async {
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    _getPlan(_page);
    super.onReady();
  }

  void _getPlan(int page, {bool? queryMore = false}) async {
    try {
      await _paymentUseCases.getUseCase.plan(page).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.plans.clear();
          response.data.forEach((item) {
            if (item.id == 1) return;
            this.plans.add(item);
          });
          if (response.data.length < response.meta.total) {
            _page = _page + 1;
            isEnableQueryMore = true;
            queryStatus = DataStatus.QUERY_MORE;
          } else {
            queryStatus = DataStatus.COMPLETED;
          }
        } else {
          if (queryMore == false) {
            queryStatus = DataStatus.EMPTY;
          } else {
            queryStatus = DataStatus.COMPLETED;
          }
        }
      });
      update();
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getPlan(page, queryMore: queryMore);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  double calculateDiscountPercentage(double price, double discount) {
    return (discount / price) * 100;
  }

  void purchase(Plan item) async {
    _loading.show();
    try {
      await _paymentUseCases.purchaseUseCase.purchase(item).then((response) {
        _loading.hide();
        AppDialog().showPayment(context);
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this.purchase(item);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }
}
