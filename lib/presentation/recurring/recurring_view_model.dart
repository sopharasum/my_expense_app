import 'package:expense_app/config/ads/ads_service.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/day_of_week.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/usecases/recurring/recurring_use_cases.dart';
import 'package:expense_app/presentation/recurring_form/recurring_form_page.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecurringViewModel extends GetxController with ScrollMixin {
  final BuildContext context;
  final bool isDarkMode;
  final RecurringUseCases _recurringUseCases = Get.find();
  final MaterialLoading _loading = Get.find();

  DataStatus queryStatus = DataStatus.LOADING;
  List<Recurring> recurrences = [];
  int _page = 0;
  bool _isEnableQueryMore = false;

  late String language;

  RecurringViewModel(this.context, this.isDarkMode);

  @override
  void onInit() async {
    language = await getLanguage();
    super.onInit();
  }

  @override
  void onReady() {
    _getRecurrences(_page);
    super.onReady();
  }

  void _getRecurrences(int page, {bool? queryMore = false}) async {
    try {
      await _recurringUseCases.getUseCase.get(page).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.recurrences.clear();
          this.recurrences.addAll(response.data);
          if (response.data.length < response.meta.total) {
            _page = _page + 1;
            _isEnableQueryMore = true;
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
          this._getRecurrences(page);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void delete(Recurring recurring) async {
    _loading.show();
    showInterstitialAd(
      loading: _loading,
      notHidden: true,
      onCompleted: () async {
        try {
          await _recurringUseCases.deleteUseCase
              .delete(recurring.recurringId)
              .then((message) {
            SnackBarUtil.showSnackBar(context, message);
            recurrences.removeAt(recurrences.indexOf(recurring));
            _loading.hide();
            update();
          });
          update();
        } on ApiError catch (error) {
          switch (error.apiErrorType) {
            case ApiErrorType.NO_INTERNET:
              _loading.hide();
              SnackBarUtil.showSnackBar(context, "No Internet Connection");
              break;
            case ApiErrorType.EXPIRE_TOKEN:
              this.delete(recurring);
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

  void refreshData() {
    queryStatus = DataStatus.LOADING;
    _page = 0;
    update();
    _getRecurrences(_page);
  }

  String getStartDate(String? date) {
    final createdAt = DateTime.parse(date.toString());
    final tomorrow = createdAt.add(Duration(days: 1));
    final format = DateFormat("yyyy-MM-dd").format(tomorrow);
    return EntryUtil.showDate(language, format);
  }

  String getTime(Recurring item) {
    final dateTime = "${item.recurringDate} ${item.recurringTime}";
    return EntryUtil.showTime(language, dateTime);
  }

  String getPrice(Recurring item) {
    return EntryUtil.getCurrency(item.recurringCurrency, item.recurringAmount);
  }

  List<DayOfWeek> getScheduledDay(Recurring recurring) {
    return recurring.dayOfWeek;
  }

  void navigateToForm(Recurring recurring) {
    Get.to(() => RecurringFormPage(recurring, language, isDarkMode))
        ?.then((result) {
      if (result != null) {
        final index = recurrences.indexWhere(
            (element) => element.recurringId == recurring.recurringId);
        recurrences[index] = result;
        update();
      }
    });
  }

  @override
  Future<void> onEndScroll() async {
    if (_isEnableQueryMore) {
      _isEnableQueryMore = false;
      _getRecurrences(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}
}
