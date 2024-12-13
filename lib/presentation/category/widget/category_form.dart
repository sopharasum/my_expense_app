import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/presentation/category/category_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryForm {
  void show({
    required BuildContext context,
    required CategoryViewModel viewModel,
    required String? type,
    Category? category,
    bool? isUpdate,
    required Function dismiss,
  }) async {
    bool nameIncorrect = false;
    if (category != null) {
      viewModel.nameController.text = "${category.categoryName}";
    } else {
      viewModel.nameController.clear();
    }

    return showDialog(
      context: context,
      builder: (context) {
        String? selectedType =
            category != null ? category.categoryType : "income";
        int id = category != null
            ? category.categoryType == "ledger"
                ? 2
                : 1
            : 1;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              isUpdate == true
                  ? type == "ledger"
                      ? "${"label_update_expense_category".tr}"
                      : "${"label_update_income_category".tr}"
                  : type == "ledger"
                      ? "${"button_add_new_expense_category".tr}"
                      : "${"button_add_new_income_category".tr}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: viewModel.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: viewModel.isDarkMode ? Colors.white : Colors.black,
                    ),
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      hintText: type == "ledger"
                          ? "${"title_expense_category".tr}"
                          : "${"title_income_category".tr}",
                      errorText: nameIncorrect
                          ? type == "ledger"
                              ? "${"label_add_expense_category_error".tr}"
                              : "${"label_add_income_category_error".tr}"
                          : null,
                    ),
                  ),
                  if (type == null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (value) => setState(() {
                            selectedType = "income";
                            id = 1;
                          }),
                        ),
                        CustomText(text: "ចំណូល"),
                        Radio(
                          value: 2,
                          groupValue: id,
                          onChanged: (value) => setState(() {
                            selectedType = "ledger";
                            id = 2;
                          }),
                        ),
                        CustomText(text: "ចំណាយ")
                      ],
                    )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  dismiss.call();
                },
                child: Text(
                  "button_cancel".tr,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    viewModel.nameController.text.isEmpty
                        ? nameIncorrect = true
                        : nameIncorrect = false;
                  });
                  if (viewModel.nameController.text.isNotEmpty) {
                    Navigator.of(context).pop();
                    dismiss.call();
                    isUpdate == true
                        ? viewModel.updateCategory(
                            category?.categoryId,
                            type == null ? selectedType : null,
                          )
                        : viewModel.addCategory(
                            type: type == null ? selectedType : null,
                          );
                  }
                },
                child: Text(
                  isUpdate == true
                      ? "${"button_update".tr}"
                      : "${"button_add".tr}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
