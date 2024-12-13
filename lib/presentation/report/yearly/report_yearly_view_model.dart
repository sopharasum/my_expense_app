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
import 'package:expense_app/presentation/report/widget/report_export_bottom_sheet.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/excel_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/pdf_util.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReportYearlyViewModel extends GetxController {
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

  late ReportYearlyData reportData;
  late TextEditingController yearController;
  late DateTime selectedYear;

  ReportYearlyViewModel(this.context, this.ledgerReport);

  @override
  void onInit() async {
    yearController = TextEditingController();
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    getSelectYear(DateTime.now());
    super.onReady();
  }

  void _getYearlyReport() async {
    try {
      await _reportUseCases.getUseCase
          .yearly(
        EntryUtil.getStartYear(selectedYear),
        EntryUtil.getEndYear(selectedYear),
      )
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
          this._getYearlyReport();
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
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

  void getSelectYear(DateTime year) {
    selectedYear = year;
    _getDateLocale(year);
    queryStatus = DataStatus.LOADING;
    update();
    _getYearlyReport();
  }

  void _getDateLocale(DateTime year) async {
    await getLanguage().then((language) {
      if (language == "en") {
        yearController.text = Formatter.fullYearFormat(year);
      } else {
        yearController.text = KhmerDate.date(
          year.toString(),
          format: "ឆ្នាំyyyy",
        );
      }
    });
  }

  void showExportType() {
    ReportExportBottomSheet().show(
      context: context,
      onSelectedType: (value) => _showRewardedAd(value),
    );
  }

  void _showRewardedAd(ExportType? value) {
    if (queryStatus == DataStatus.LOADING) return;
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () => _downloadReport(value),
    );
  }

  void navigateToPage(Widget page) {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      onCompleted: () => Get.to(() => page, binding: MainBinding())
          ?.then((status) => _shouldRefreshPage(status)),
    );
  }

  void _shouldRefreshPage(bool status) {
    if (status) {
      queryStatus = DataStatus.LOADING;
      ledgers.clear();
      incomes.clear();
      shouldRefreshData = status;
      update();
      _getYearlyReport();
    }
  }

  void _downloadReport(ExportType? exportType) async {
    final isDataEmpty = ledgerReport ? ledgers.isEmpty : incomes.isEmpty;
    final type = ledgerReport ? "ledger" : "income";
    if (isDataEmpty) {
      try {
        await _reportUseCases.getUseCase
            .dateRange(
          type,
          EntryUtil.getStartYear(selectedYear),
          EntryUtil.getEndYear(selectedYear),
        )
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
            isYearly: true,
            dateTime: selectedYear,
            ledgerReport: ledgerReport,
            ledgers: ledgers,
            incomes: incomes,
            onShare: (value) => _shareFile(value));
        break;
      default:
        ExcelUtil().createExcel(
          isYearly: true,
          dateTime: selectedYear,
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
}
