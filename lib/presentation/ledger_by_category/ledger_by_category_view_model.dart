import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:expense_app/domain/usecases/ledger/ledger_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/ledger_form/ledger_form_page.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LedgerByCategoryViewModel extends GetxController with ScrollMixin {
  final LedgerUseCases _ledgerUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();
  final List<Entry> ledgers = [];
  final BuildContext context;
  final ReportCategory category;
  final DateTime selectedMonth;

  late String language;

  DataStatus queryStatus = DataStatus.LOADING;
  bool shouldRefreshData = false;
  int _page = 0;
  bool isEnableQueryMore = false;
  bool isDarkMode = false;

  LedgerByCategoryViewModel(this.context, this.category, this.selectedMonth);

  @override
  void onInit() async {
    language = await getLanguage();
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    _getFilter(_page);
    super.onReady();
  }

  void _getFilter(int page, {bool? queryMore = false}) async {
    final filter = Filter(
      categoryId: category.id,
      startDate: EntryUtil.getStartMonth(selectedMonth),
      endDate: EntryUtil.getEndMonth(selectedMonth),
    );
    try {
      await _ledgerUseCases.getUseCase.filter(page, filter).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.ledgers.clear();
          this.ledgers.addAll(response.data);
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
        update();
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getFilter(page);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  double grandTotalInCurrency(String currency) {
    return EntryUtil.grandTotalInCurrency(ledgers, currency);
  }

  void navigateToLedgerForm(Entry ledger) {
    Get.to(
      () => LedgerFormPage(
        pageTitle: "${"title_update_expense".tr}",
        isDarkMode: isDarkMode,
        language: language,
        isUpdate: true,
        ledger: ledger,
      ),
      binding: MainBinding(),
    )?.then((status) => refreshData(status));
  }

  void deleteLedger(int? ledgerId) async {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () async {
        try {
          await _ledgerUseCases.deleteUseCase.delete(ledgerId).then((message) {
            SnackBarUtil.showSnackBar(context, message);
            final index =
                ledgers.indexWhere((item) => item.entryId == ledgerId);
            ledgers.removeAt(index);
            _loading.hide();
            shouldRefreshData = true;
            update();
          });
        } on ApiError catch (error) {
          switch (error.apiErrorType) {
            case ApiErrorType.NO_INTERNET:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, "No Internet Connection");
              break;
            case ApiErrorType.EXPIRE_TOKEN:
              this.deleteLedger(ledgerId);
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

  void refreshData(bool status, {bool? reload = false}) async {
    if (status) {
      if (reload == false) shouldRefreshData = status;
      queryStatus = DataStatus.LOADING;
      _page = 0;
      update();
      _getFilter(_page);
    }
  }

  @override
  Future<void> onEndScroll() async {
    if (isEnableQueryMore) {
      isEnableQueryMore = false;
      _getFilter(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}
}
