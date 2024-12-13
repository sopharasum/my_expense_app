import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/extension.dart';
import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/config/khmer_date.dart';
import 'package:expense_app/config/localization_service.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/ads_source_pref.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/data/data_sources/preference/no_ads_pref.dart';
import 'package:expense_app/data/data_sources/preference/payment_pref.dart';
import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/data/data_sources/preference/user_guide_pref.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:expense_app/domain/entities/payment.dart';
import 'package:expense_app/domain/usecases/accountant/accountant_use_cases.dart';
import 'package:expense_app/domain/usecases/income/income_use_cases.dart';
import 'package:expense_app/domain/usecases/ledger/ledger_use_cases.dart';
import 'package:expense_app/domain/usecases/payment/payment_use_cases.dart';
import 'package:expense_app/domain/usecases/report/report_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/donate/donate_page.dart';
import 'package:expense_app/presentation/faq/faq_page.dart';
import 'package:expense_app/presentation/income_form/income_form_page.dart';
import 'package:expense_app/presentation/ledger_form/ledger_form_page.dart';
import 'package:expense_app/presentation/login/login_page.dart';
import 'package:expense_app/presentation/report/monthly/report_page.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/show_app_update_dialog.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeViewModel extends GetxController
    with ScrollMixin, WidgetsBindingObserver {
  final BuildContext context;
  final ThemeMode themeMode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PaymentUseCases _paymentUseCases = Get.find();
  final AccountantUseCases _accountantUseCases = Get.find();
  final ReportUseCases _reportUseCases = Get.find();
  final LedgerUseCases _ledgerUseCases = Get.find();
  final IncomeUseCases _incomeUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();

  DataStatus queryStatus = DataStatus.LOADING;
  DataStatus ledgerStatus = DataStatus.EMPTY;
  DataStatus incomeStatus = DataStatus.EMPTY;
  DataStatus queryMoreStatus = DataStatus.COMPLETED;
  bool ledgerOperation = true;
  int _page = 0;
  bool isEnableQueryMore = false;
  bool isClickedUpdate = false;

  bool? isFromLogin;

  late Filter filter;
  late bool isDarkMode;

  HomeViewModel({
    required this.context,
    required this.themeMode,
    this.isFromLogin,
  });

  List<Entry> ledgers = [];
  List<Entry> incomes = [];
  double totalKHR = 0.0;
  double totalUSD = 0.0;

  late String? currentDate;
  String? selectedLanguage;
  String? appVersion;
  Accountant? accountant;
  Payment? payment;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    isDarkMode = themeMode.name == ThemeMode.dark.name;
    filter = Filter(
      startDate: EntryUtil.getStartDay(DateTime.now()),
      endDate: EntryUtil.getEndDay(DateTime.now()),
    );
    accountant = await getLoggedAccount();
    await PackageInfo.fromPlatform()
        .then((value) => appVersion = value.version);
    _getDateLocale();
    super.onInit();
  }

  @override
  void onReady() async {
    if (isFromLogin != null && isFromLogin == true) {
      await getGuided().then((value) {
        if (!value)
          AppDialog().showConfirm(
            context,
            "title_user_guide".tr,
            "msg_user_guide".tr,
            () => Get.to(
              () => FAQPage(selectedLanguage.toString()),
              binding: MainBinding(),
            ),
          );
        setGuided(true);
      });
    }
    _getPayment();
    super.onReady();
  }

  void _getPayment() async {
    try {
      await _paymentUseCases.getUseCase.status().then((response) {
        printInfo(info: "payment => ${response.data.paymentStatus}");
        payment = response.data;
        setPayment(response.data);
      });
      _getConfiguration();
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getPayment();
          break;
        case ApiErrorType.ERROR_REQUEST:
          switch (error.apiMessage?.code) {
            case 402:
              await getDate().then((value) {
                if (value == null ||
                    !(DateTime.now()
                        .isSameDate(DateTime.parse(value.toString())))) {
                  AppDialog().showSubscription(
                    context,
                    () => Get.to(() => DonatePage()),
                  );
                }
                setDate(DateTime.now());
              });
              payment = null;
              removePayment();
              _getConfiguration();
              break;
            case 404:
              Get.off(LoginPage());
              SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
              break;
            default:
              SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
              break;
          }
          break;
      }
    }
  }

  void _getConfiguration() async {
    try {
      await _accountantUseCases.configurationUseCase.get().then((response) {
        setAdsSource(response.data.advertiseSource);
        ShowAppUpdateDialog().checkForMaintenance(
          context,
          response.data,
          (bool) => isClickedUpdate = bool,
        );
        _getTodaySummaryReport();
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getConfiguration();
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _getTodaySummaryReport() async {
    try {
      await _reportUseCases.getUseCase
          .get(EntryUtil.getStartDay(DateTime.now()),
              EntryUtil.getEndDay(DateTime.now()))
          .then((data) {
        if (ledgerOperation) {
          totalKHR = data.summary.subtotalLedger.khAmount;
          totalUSD = data.summary.subtotalLedger.usAmount;
        } else {
          totalKHR = data.summary.subtotalIncome.khAmount;
          totalUSD = data.summary.subtotalIncome.usAmount;
        }
        ledgerOperation ? _getLedgers(_page) : _getIncomes(_page);
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getTodaySummaryReport();
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _getLedgers(int page, {bool? queryMore = false}) async {
    try {
      await _ledgerUseCases.getUseCase.filter(page, filter).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.ledgers.clear();
          this.ledgers.addAll(response.data);
          ledgerStatus = DataStatus.COMPLETED;
          if (response.data.length < response.meta.total) {
            _page = _page + 1;
            isEnableQueryMore = true;
            queryMoreStatus = DataStatus.QUERY_MORE;
          } else {
            queryMoreStatus = DataStatus.COMPLETED;
          }
        } else {
          if (queryMore == false) {
            ledgerStatus = DataStatus.EMPTY;
          } else {
            queryMoreStatus = DataStatus.COMPLETED;
          }
        }
      });
      queryStatus = DataStatus.COMPLETED;
      update();
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getLedgers(page, queryMore: queryMore);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _getIncomes(int page, {bool? queryMore = false}) async {
    try {
      await _incomeUseCases.getUseCase.filter(page, filter).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.incomes.clear();
          this.incomes.addAll(response.data);
          incomeStatus = DataStatus.COMPLETED;
          if (response.data.length < response.meta.total) {
            _page = _page + 1;
            isEnableQueryMore = true;
            queryMoreStatus = DataStatus.QUERY_MORE;
          } else {
            queryMoreStatus = DataStatus.COMPLETED;
          }
        } else {
          if (queryMore == false) {
            incomeStatus = DataStatus.EMPTY;
          } else {
            queryMoreStatus = DataStatus.COMPLETED;
          }
        }
      });
      queryStatus = DataStatus.COMPLETED;
      update();
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getIncomes(page, queryMore: queryMore);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void navigateToLedgerForm({Entry? ledger}) {
    Get.to(
      () => LedgerFormPage(
        pageTitle: ledger != null
            ? "${"title_update_expense".tr}"
            : "${"title_add_new_expense".tr}",
        isDarkMode: isDarkMode,
        language: selectedLanguage.toString(),
        isUpdate: ledger != null ? true : false,
        ledger: ledger,
      ),
      binding: MainBinding(),
    )?.then((status) => shouldRefreshPage(status));
  }

  void navigateToIncomeForm({Entry? income}) {
    Get.to(
            () => IncomeFormPage(
                  pageTitle: income != null
                      ? "${"title_update_income".tr}"
                      : "${"title_add_new_income".tr}",
                  isDarkMode: isDarkMode,
                  language: selectedLanguage.toString(),
                  isUpdate: income != null ? true : false,
                  income: income,
                ),
            binding: MainBinding())
        ?.then((status) => shouldRefreshPage(status));
  }

  void navigateToReportPage() {
    if (queryStatus != DataStatus.LOADING) {
      _loading.show();
      showInterstitialAd(
        loading: _loading,
        onCompleted: () =>
            Get.to(() => ReportPage(ledgerOperation), binding: MainBinding())
                ?.then((status) => shouldRefreshPage(status)),
      );
    }
  }

  void shouldRefreshPage(bool data) {
    if (data) {
      queryStatus = DataStatus.LOADING;
      _page = 0;
      update();
      _getTodaySummaryReport();
    }
  }

  void deleteEntry(Entry entry, bool isLedger) {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () => isLedger ? _deleteLedger(entry) : _deleteIncome(entry)
    );
  }

  void _deleteLedger(Entry ledger) async {
    _loading.show();
    try {
      await _ledgerUseCases.deleteUseCase
          .delete(ledger.entryId)
          .then((message) {
        SnackBarUtil.showSnackBar(context, message);
        ledgers.removeAt(ledgers.indexOf(ledger));
        _loading.hide();
        if (ledgers.isEmpty) {
          shouldRefreshPage(true);
        } else {
          _calculateTotalAmount(ledgers);
          update();
        }
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._deleteLedger(ledger);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _deleteIncome(Entry income) async {
    _loading.show();
    try {
      await _incomeUseCases.deleteUseCase
          .delete(income.entryId)
          .then((message) {
        SnackBarUtil.showSnackBar(context, message);
        incomes.removeAt(incomes.indexOf(income));
        _loading.hide();
        if (incomes.isEmpty) {
          shouldRefreshPage(true);
        } else {
          _calculateTotalAmount(incomes);
          update();
        }
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._deleteIncome(income);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _calculateTotalAmount(List<Entry> list) {
    double khAmount = 0.0;
    double usAmount = 0.0;
    list.forEach((element) {
      if (element.entryCurrency == "KHR")
        khAmount = khAmount + element.entryAmount!;
      else
        usAmount = usAmount + element.entryAmount!;
    });
    totalKHR = khAmount;
    totalUSD = usAmount;
  }

  void changeLanguage() {
    getLanguage().then((language) {
      selectedLanguage = language;
      var newLanguage = language == "en" ? "km" : "en";
      LocalizationService().changeLocale(newLanguage);
      setLanguage(newLanguage).then((value) {
        _getDateLocale();
        update();
      });
    });
  }

  void _getDateLocale() async {
    await getLanguage().then((language) {
      selectedLanguage = language;
      if (language == "en") {
        currentDate = Formatter.dateFormat(DateTime.now());
      } else {
        currentDate = KhmerDate.date(
          DateTime.now().toString(),
          format: "ថ្ងៃdddd ទីdd ខែmmm ឆ្នាំyyyy",
        );
      }
    });
  }

  void toggle() {
    if (queryStatus != DataStatus.LOADING) {
      _loading.show();
      showInterstitialAd(
        loading: _loading,
        onCompleted: () {
          ledgerOperation = !ledgerOperation;
          queryStatus = DataStatus.LOADING;
          _page = 0;
          update();
          _getTodaySummaryReport();
        },
      );
    }
  }

  void logout() {
    AppDialog().showConfirm(
      context,
      "msg_logout_title".tr,
      "msg_logout".tr,
      () async => await removeLoggedAccountant().then((_) {
        _auth.signOut();
        Get.off(LoginPage());
      }),
    );
  }

  void addNewRecord() {
    if (queryStatus != DataStatus.LOADING) {
      ledgerOperation ? navigateToLedgerForm() : navigateToIncomeForm();
    }
  }

  String? getLastLogin() {
    return accountant?.accountantLastLogin != null
        ? Formatter.dateHourFormat(accountant?.accountantLastLogin)
        : "label_other_n_a".tr;
  }

  void switchTheme() {
    _themeService.switchTheme();
    isDarkMode = !isDarkMode;
    update();
  }

  @override
  Future<void> onEndScroll() async {
    if (isEnableQueryMore) {
      isEnableQueryMore = false;
      ledgerOperation
          ? _getLedgers(_page, queryMore: true)
          : _getIncomes(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (isClickedUpdate) {
          isClickedUpdate = !isClickedUpdate;
          _getConfiguration();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
