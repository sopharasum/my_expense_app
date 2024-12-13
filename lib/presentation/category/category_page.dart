import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/category/category_view_model.dart';
import 'package:expense_app/presentation/category/widget/category_data_empty_section.dart';
import 'package:expense_app/presentation/category/widget/category_data_section.dart';
import 'package:expense_app/presentation/category/widget/category_form.dart';
import 'package:expense_app/presentation/category/widget/category_shimmer.dart';
import 'package:expense_app/presentation/widget/custom_ads_banner.dart';
import 'package:expense_app/presentation/widget/custom_app_bar.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  final String? title;
  final String? type;
  final bool? notBack;
  final String language;

  CategoryPage({
    this.title,
    required this.language,
    this.type,
    this.notBack,
  });

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return GetBuilder<CategoryViewModel>(
      init: CategoryViewModel(context, language, type, notBack),
      builder: (viewModel) => Scaffold(
        appBar: customAppBar(
          title == null
              ? type == "ledger"
                  ? "${"title_expense_category".tr}"
                  : "${"title_income_category".tr}"
              : "$title",
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(
                color: viewModel.isDarkMode ? Colors.white : Colors.black,
              ),
              focusNode: focusNode,
              controller: viewModel.searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: type == null
                    ? "label_search_category_hint".tr
                    : type == "ledger"
                        ? "${"label_search_expense_category_hint".tr}"
                        : "${"label_search_income_category_hint".tr}",
                suffixIcon: GestureDetector(
                  onTap: () async {
                    focusNode.unfocus();
                    focusNode.canRequestFocus = false;
                    viewModel.clear();
                  },
                  child: Icon(Icons.clear),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (keyword) => viewModel.search(keyword),
              onChanged: (keyword) => viewModel.search(keyword),
            ),
            viewModel.queryStatus == DataStatus.LOADING
                ? Expanded(child: CategoryShimmer())
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => viewModel.reloadData(),
                      child: CustomScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        semanticChildCount: viewModel.categories.length,
                        slivers: [
                          viewModel.categories.isEmpty
                              ? CategoryDataEmptySection(viewModel, type)
                              : CategoryDataSection(viewModel)
                        ],
                      ),
                    ),
                  ),
            CustomAdsBanner(),
            GestureDetector(
              onTap: () => CategoryForm().show(
                context: context,
                viewModel: viewModel,
                type: type,
                dismiss: () => FocusScope.of(context).requestFocus(
                  new FocusNode(),
                ),
              ),
              child: CustomButton(
                type == null
                    ? "button_add_new_category".tr
                    : type == "ledger"
                        ? "${"button_add_new_expense_category".tr}"
                        : "${"button_add_new_income_category".tr}",
                Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
