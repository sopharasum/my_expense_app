import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/faq.dart';
import 'package:expense_app/domain/usecases/faq/faq_use_cases.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FAQViewModel extends GetxController with ScrollMixin {
  final BuildContext context;
  final String language;
  final FaqUseCases _useCases = Get.find();

  List<Faq> faqs = [];
  DataStatus queryStatus = DataStatus.LOADING;
  int _page = 0;
  bool _isEnableQueryMore = false;

  FAQViewModel(this.context, this.language);

  @override
  void onReady() {
    _getFaqs(_page);
    super.onReady();
  }

  void _getFaqs(int page, {bool? queryMore = false}) async {
    try {
      await _useCases.getUseCase.get(page).then((response) {
        if (response.data.isNotEmpty) {
          if (queryMore == false) this.faqs.clear();
          this.faqs.addAll(response.data);
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
          this._getFaqs(page, queryMore: queryMore);
          break;
        case ApiErrorType.ERROR_REQUEST:
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void reload() {
    queryStatus = DataStatus.LOADING;
    _page = 0;
    update();
    _getFaqs(_page);
  }

  @override
  Future<void> onEndScroll() async {
    if (_isEnableQueryMore) {
      _isEnableQueryMore = false;
      _getFaqs(_page, queryMore: true);
    }
  }

  @override
  Future<void> onTopScroll() async {}
}
