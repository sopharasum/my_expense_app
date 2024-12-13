import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/config/khmer_date.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:expense_app/domain/usecases/report/report_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/income_by_category/income_by_category_page.dart';
import 'package:expense_app/presentation/ledger_by_category/ledger_by_category_page.dart';
import 'package:expense_app/presentation/report/widget/report_export_bottom_sheet.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/excel_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/pdf_util.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReportViewModel extends GetxController {
  final BuildContext context;
  final ReportUseCases _reportUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();

  DataStatus queryStatus = DataStatus.LOADING;
  bool shouldRefreshData = false;
  List<Entry> ledgers = [];
  List<Entry> incomes = [];
  bool isDarkMode = false;
  late bool ledgerReport;

  late ReportData reportData;
  late TextEditingController monthController;
  late DateTime selectedMonth;

  ReportViewModel(this.context, this.ledgerReport);

  @override
  void onInit() async {
    monthController = TextEditingController();
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    getSelectMonth(DateTime.now());
    super.onReady();
  }

  void _getReport() async {
    try {
      await _reportUseCases.getUseCase
          .get(EntryUtil.getStartMonth(selectedMonth),
              EntryUtil.getEndMonth(selectedMonth))
          .then((data) {
        this.reportData = data;
        queryStatus = DataStatus.COMPLETED;
        update();
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getReport();
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void navigateToPage(Widget page) {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      onCompleted: () => Get.to(() => page, binding: MainBinding())
          ?.then((status) => _shouldRefreshPage(status)),
    );
  }

  void navigateToLedgerPage(ReportCategory category) {
    Get.to(() => LedgerByCategoryPage(category, selectedMonth))
        ?.then((status) => _shouldRefreshPage(status));
  }

  void navigateToIncomePage(ReportCategory category) {
    Get.to(() => IncomeByCategoryPage(category, selectedMonth))
        ?.then((status) => _shouldRefreshPage(status));
  }

  void _shouldRefreshPage(bool status) {
    if (status) {
      queryStatus = DataStatus.LOADING;
      ledgers.clear();
      incomes.clear();
      shouldRefreshData = status;
      update();
      _getReport();
    }
  }

  void getSelectMonth(DateTime month) {
    selectedMonth = month;
    _getDateLocale(month);
    ledgers.clear();
    incomes.clear();
    queryStatus = DataStatus.LOADING;
    update();
    _getReport();
  }

  void _getDateLocale(DateTime month) async {
    await getLanguage().then((language) {
      if (language == "en") {
        monthController.text = Formatter.fullMonthYearFormat(month);
      } else {
        monthController.text = KhmerDate.date(
          month.toString(),
          format: "ខែmmm ឆ្នាំyyyy",
        );
      }
    });
  }

  void toggleReport() {
    if (queryStatus != DataStatus.LOADING) {
      _loading.show();
      showInterstitialAd(
        loading: _loading,
        onCompleted: () {
          ledgerReport = !ledgerReport;
          update();
        },
      );
    }
  }

  void showExportType() {
    ReportExportBottomSheet().show(
      context: context,
      onSelectedType: (value) => showRewardedAd(value),
    );
  }

  void showRewardedAd(ExportType? value) {
    if (queryStatus == DataStatus.LOADING) return;
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () => _downloadReport(value),
    );
  }

  void _downloadReport(ExportType? exportType) async {
    final isDataEmpty = ledgerReport ? ledgers.isEmpty : incomes.isEmpty;
    final type = ledgerReport ? "ledger" : "income";
    if (isDataEmpty) {
      try {
        await _reportUseCases.getUseCase
            .dateRange(type, EntryUtil.getStartMonth(selectedMonth),
                EntryUtil.getEndMonth(selectedMonth))
            .then((value) {
          if (value.isNotEmpty) {
            if (ledgerReport) {
              ledgers.clear();
              ledgers.addAll(value);
            } else {
              incomes.clear();
              incomes.addAll(value);
            }
            exportOperation(exportType);
          } else {
            _loading.hide();
            SnackBarUtil.showSnackBar(context, "There is no data to export");
          }
        });
      } on ApiError catch (error) {
        switch (error.apiErrorType) {
          case ApiErrorType.NO_INTERNET:
            _loading.hide();
            SnackBarUtil.showSnackBar(context, "No Internet Connection");
            break;
          case ApiErrorType.EXPIRE_TOKEN:
            this._downloadReport(exportType);
            break;
          case ApiErrorType.ERROR_REQUEST:
            _loading.hide();
            SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
            break;
        }
      }
    } else {
      exportOperation(exportType);
    }
  }

  void exportOperation(ExportType? exportType) {
    switch (exportType) {
      case ExportType.pdf:
        PDFUtil().htmlToPdf(
            isYearly: false,
            dateTime: selectedMonth,
            ledgerReport: ledgerReport,
            ledgers: ledgers,
            incomes: incomes,
            onShare: (value) => _shareFile(value));
        break;
      default:
        ExcelUtil().createExcel(
          isYearly: false,
          dateTime: selectedMonth,
          ledgerReport: ledgerReport,
          incomes: incomes,
          ledgers: ledgers,
          onShare: (value) => _shareFile(value),
        );
        break;
    }
  }

  Future<void> _shareFile(String fileName) async {
    _loading.hide();
    await Share.shareXFiles([XFile(fileName)]);
  }

  @override
  void dispose() {
    monthController.dispose();
    super.dispose();
  }
}
