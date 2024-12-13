import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/presentation/widget/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryCategorySelector extends StatelessWidget {
  final ThemeService _themeService = Get.find();
  final List<Category> categories;
  final TextEditingController controller;
  final String type;
  final String categoryHint;
  final String hint;
  final Function(Category) onSelected;

  EntryCategorySelector(
    this.categories,
    this.controller,
    this.type,
    this.categoryHint,
    this.hint,
    this.onSelected,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _themeService.loadThemeFromPref(),
      builder: (context, snapshot) => Expanded(
        child: TextFormField(
          style: TextStyle(
            color: (snapshot.data != null && snapshot.data == true)
                ? Colors.white
                : Colors.black,
          ),
          onTap: () => CategoryBottomSheet().show(
            context,
            categories,
            type,
            categoryHint,
            (category) => onSelected(category),
          ),
          enableInteractiveSelection: false,
          readOnly: true,
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down),
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
