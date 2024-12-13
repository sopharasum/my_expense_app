import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/transaction.dart';
import 'package:expense_app/domain/usecases/payment/payment_use_cases.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TransactionViewModel extends GetxController with ScrollMixin {
  final BuildContext context;
  final PaymentUseCases _paymentUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();

  DataStatus queryStatus = DataStatus.LOADING;
  List<Transaction> transactions = [];

  int _page = 0;
  bool isEnableQueryMore = false;
  bool isDarkMode = false;

  String? language;

  TransactionViewModel(this.context);

  @override
  void onInit() async {
    await getLanguage().then((value) => language = value);
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    _getTransaction(_page);
    super.onReady();
  }

  void _getTransaction(int page, {bool? queryMore = false}) async {
    try {
      await _paymentUseCases.getUseCase.transaction(page).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.transactions.clear();
          this.transactions.addAll(response.data);
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
          this._getTransaction(page, queryMore: queryMore);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void cancel(int index, Transaction item) async {
    _loading.show();
    try {
      await _paymentUseCases.updateStatusUseCase
          .update(item.transactionId)
          .then((response) {
        if (response.data.purchaseId != null) {
          transactions[index].transactionStatus =
              response.data.purchaseStatus.toString();
          _loading.hide();
          update();
          SnackBarUtil.showSnackBar(
            context,
            "msg_transaction_cancel_success".tr,
          );
        }
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this.cancel(index, item);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void reloadData() {
    queryStatus = DataStatus.LOADING;
    _page = 0;
    update();
    _getTransaction(_page);
  }

  @override
  Future<void> onEndScroll() async {
    if (isEnableQueryMore) {
      isEnableQueryMore = false;
      _getTransaction(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}
}
