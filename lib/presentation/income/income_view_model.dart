import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/entities/date_range.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:expense_app/domain/usecases/category/category_use_cases.dart';
import 'package:expense_app/domain/usecases/income/income_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/income_form/income_form_page.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomeViewModel extends GetxController with ScrollMixin {
  final BuildContext context;
  final CategoryUseCases _categoryUseCases = Get.find();
  final IncomeUseCases _incomeUseCases = Get.find();
  final MaterialLoading _loading = Get.find();
  final ThemeService _themeService = Get.find();

  late TextEditingController categoryController;
  late TextEditingController dateController;
  late String language;

  DataStatus queryStatus = DataStatus.LOADING;
  List<Category> categories = [];
  List<Entry> incomes = [];
  Category? categorySelected;
  DateRange? selectedDateRange;
  bool shouldRefreshData = false;
  bool isFiltering = false;
  int _page = 0;
  bool isEnableQueryMore = false;
  bool isDarkMode = false;

  IncomeViewModel(this.context);

  @override
  void onInit() async {
    categoryController = TextEditingController();
    dateController = TextEditingController();
    language = await getLanguage();
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    _getCategories();
    super.onReady();
  }

  void _getCategories() async {
    isFiltering = false;
    try {
      await _categoryUseCases.getUseCase.get("income").then((categories) {
        if (categories.isNotEmpty) {
          this.categories.clear();
          this.categories.addAll(categories);
          _getIncomes(0);
        } else {
          queryStatus = DataStatus.EMPTY;
          update();
        }
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this._getCategories();
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _getIncomes(int page, {bool? queryMore = false}) async {
    try {
      await _incomeUseCases.getUseCase.get(page).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.incomes.clear();
          this.incomes.addAll(response.data);
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
          this._getIncomes(page);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _getIncomesByFilter(int page, {bool? queryMore = false}) async {
    isFiltering = true;
    final filter = Filter(
      categoryId:
          categorySelected == null ? null : categorySelected?.categoryId,
      startDate: selectedDateRange == null ? null : selectedDateRange?.start,
      endDate: selectedDateRange == null ? null : selectedDateRange?.end,
    );
    try {
      await _incomeUseCases.getUseCase.filter(page, filter).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.incomes.clear();
          this.incomes.addAll(response.data);
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
          this._getIncomesByFilter(page);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void selectedCategory(Category category) {
    categorySelected = category;
    categoryController.text = "${category.categoryName}";
    _filterIncome();
  }

  void getSelectedDateRange(DateRange dateRange) {
    selectedDateRange = dateRange;
    dateController.text = dateRange.label;
    _filterIncome();
  }

  void _filterIncome() {
    queryStatus = DataStatus.LOADING;
    _page = 0;
    update();
    _getIncomesByFilter(_page);
  }

  void refreshData(bool refresh, {bool? reload = false}) {
    if (refresh) {
      if (reload == false) shouldRefreshData = refresh;
      _reloadAction();
    }
  }

  void resetFilter() {
    if (queryStatus != DataStatus.LOADING) {
      isFiltering = !isFiltering;
      dateController.clear();
      categoryController.clear();
      _reloadAction();
    }
  }

  void _reloadAction() {
    queryStatus = DataStatus.LOADING;
    _page = 0;
    update();
    isFiltering ? _getIncomesByFilter(_page) : _getCategories();
  }

  void deleteIncome(Entry income) async {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () async {
        try {
          await _incomeUseCases.deleteUseCase
              .delete(income.entryId)
              .then((message) {
            incomes.removeAt(incomes.indexOf(income));
            shouldRefreshData = true;
            _loading.hide();
            SnackBarUtil.showSnackBar(context, message);
            update();
          });
        } on ApiError catch (error) {
          switch (error.apiErrorType) {
            case ApiErrorType.NO_INTERNET:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, "No Internet Connection");
              break;
            case ApiErrorType.EXPIRE_TOKEN:
              this.deleteIncome(income);
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

  void navigateToIncomeForm(Entry? income) async {
    Get.to(
      () => IncomeFormPage(
        pageTitle: "${"title_update_income".tr}",
        isDarkMode: isDarkMode,
        language: language,
        isUpdate: true,
        income: income,
      ),
      binding: MainBinding(),
    )?.then((status) => refreshData(status));
  }

  @override
  Future<void> onEndScroll() async {
    if (isEnableQueryMore) {
      isEnableQueryMore = false;
      isFiltering
          ? _getIncomesByFilter(_page, queryMore: true)
          : _getIncomes(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}

  @override
  void dispose() {
    categoryController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
