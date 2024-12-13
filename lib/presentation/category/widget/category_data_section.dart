import 'dart:math' as math;

import 'package:expense_app/presentation/category/category_view_model.dart';
import 'package:expense_app/presentation/category/widget/category_item.dart';
import 'package:flutter/material.dart';

class CategoryDataSection extends StatelessWidget {
  final CategoryViewModel viewModel;

  CategoryDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 6),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final int itemIndex = index ~/ 2;
            if (index.isEven) {
              return CategoryItem(
                viewModel,
                viewModel.categories[itemIndex],
                viewModel.type,
                () => FocusScope.of(context).requestFocus(new FocusNode()),
              );
            }
            return Divider(
              height: 0,
              color: viewModel.isDarkMode ? Colors.white.withOpacity(.5) : Colors.grey,
            );
          },
          semanticIndexCallback: (widget, localIndex) {
            if (localIndex.isEven) {
              return localIndex ~/ 2;
            }
            return null;
          },
          childCount: math.max(0, viewModel.categories.length * 2 - 1),
        ),
      ),
    );
  }
}
