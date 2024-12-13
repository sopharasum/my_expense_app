import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryBottomSheet {
  final ThemeService _themeService = Get.find();

  void show(
    BuildContext context,
    List<Category> categories,
    String type,
    String title,
    Function(Category) onSelected,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: _themeService.loadThemeFromPref(),
          builder: (context, snapshot) {
            final isDarkMode = snapshot.data != null && snapshot.data == true;
            return Container(
              height: Get.height * 0.39,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withOpacity(.3)
                            : Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: CustomText(
                      text: title,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                    ),
                  ),
                  categories.isEmpty
                      ? Expanded(
                          child: CustomText(
                            text: type == "ledger"
                                ? "${"label_expense_category_list_empty".tr}"
                                : "${"label_income_category_list_empty".tr}",
                            textAlign: TextAlign.center,
                            fontSize: 15,
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                onSelected(categories[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 4,
                                  top: 4,
                                  bottom:
                                      index == categories.length - 1 ? 12 : 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "${categories[index].categoryName}",
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => Divider(
                              color: isDarkMode ? Colors.white : Colors.blue,
                            ),
                            itemCount: categories.length,
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
