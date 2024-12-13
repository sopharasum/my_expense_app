import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/presentation/category/category_view_model.dart';
import 'package:expense_app/presentation/category/widget/category_form.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItem extends StatelessWidget {
  final CategoryViewModel viewModel;
  final Category category;
  final String? type;
  final Function dismiss;

  CategoryItem(this.viewModel, this.category, this.type, this.dismiss);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => viewModel.notBack == null ? Get.back(result: category) : {},
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: category.categoryName,
                  children: [
                    if (type == null)
                      TextSpan(
                          text:
                              " - ${viewModel.getType(category.categoryType)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => CategoryForm().show(
                context: context,
                viewModel: viewModel,
                type: type,
                category: category,
                isUpdate: true,
                dismiss: () => dismiss.call(),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.blue,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: InkWell(
                onTap: () => AppDialog().showConfirm(
                  context,
                  viewModel.type == "ledger"
                      ? "${"msg_delete_expense_category_title".tr}"
                      : "${"msg_delete_income_category_title".tr}",
                  viewModel.type == "ledger"
                      ? "${"msg_delete_expense_category".tr}"
                      : "${"msg_delete_income_category".tr}",
                  () {
                    dismiss.call();
                    viewModel.deleteCategory(category);
                  },
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
