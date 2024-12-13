import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/usecases/category/category_use_cases.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryViewModel extends GetxController {
  final BuildContext context;
  final String language;
  final String? type;
  final bool? notBack;
  final CategoryUseCases _categoryUseCases = Get.find();
  final ThemeService _themeService = Get.find();
  final MaterialLoading _loading = Get.find();

  late TextEditingController searchController;
  late TextEditingController nameController;

  DataStatus queryStatus = DataStatus.LOADING;
  List<Category> categories = [];
  List<Category> copyCategories = [];
  bool isFiltered = false;
  bool isDarkMode = false;

  CategoryViewModel(this.context, this.language, this.type, this.notBack);

  @override
  void onInit() async {
    searchController = TextEditingController();
    nameController = TextEditingController();
    isDarkMode = await _themeService.loadThemeFromPref();
    super.onInit();
  }

  @override
  void onReady() {
    _getCategories();
    super.onReady();
  }

  void _getCategories() async {
    try {
      await _categoryUseCases.getUseCase.get(type).then((categories) {
        if (categories.isNotEmpty) {
          this.categories.addAll(categories);
          this.copyCategories = List.from(categories);
          queryStatus = DataStatus.COMPLETED;
        } else {
          queryStatus = DataStatus.EMPTY;
        }
      });
      update();
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

  void search(String keyword) {
    categories.clear();
    for (int i = 0; i < copyCategories.length; i++) {
      if (copyCategories[i]
          .categoryName
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        categories.add(copyCategories[i]);
      }
    }
    update();
  }

  void clear() {
    searchController.clear();
    categories.clear();
    categories = List.from(copyCategories);
    update();
  }

  void addCategory({String? type}) async {
    _loading.show();
    Category category = Category(
      categoryName: nameController.text,
      categoryType: type ?? this.type,
    );
    try {
      await _categoryUseCases.addUseCase.add(category).then((message) {
        nameController.clear();
        _loading.hide();
        SnackBarUtil.showSnackBar(context, message);
        reloadData();
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this.addCategory(type: type);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void updateCategory(int? categoryId, String? type) async {
    _loading.show();
    Category category = Category(
      categoryId: categoryId,
      categoryName: nameController.text,
      categoryType: type ?? this.type,
    );
    try {
      await _categoryUseCases.updateUseCase.update(category).then((message) {
        nameController.clear();
        _loading.hide();
        SnackBarUtil.showSnackBar(context, message);
        categories[getIndex(categoryId)] = category;
        copyCategories[getIndex(categoryId)] = category;
        update();
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          this.updateCategory(categoryId, type);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void deleteCategory(Category category) async {
    _loading.show();
    try {
      await _categoryUseCases.deleteUseCase
          .delete(category.categoryId)
          .then((message) {
        copyCategories.removeAt(getIndex(category.categoryId));
        categories.removeAt(getIndex(category.categoryId));
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
          this.deleteCategory(category);
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.show();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  int getIndex(int? categoryId) {
    return categories.indexWhere((element) => element.categoryId == categoryId);
  }

  void reloadData() {
    queryStatus = DataStatus.LOADING;
    this.categories.clear();
    this.copyCategories.clear();
    update();
    _getCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    super.dispose();
  }

  String getType(String? type) {
    return type == "income"
        ? language == "en"
            ? "income"
            : "ចំណូល"
        : language == "en"
            ? "expense"
            : "ចំណាយ";
  }
}
