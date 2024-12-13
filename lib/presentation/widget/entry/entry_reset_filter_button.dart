import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryResetFilterButton extends StatelessWidget {
  final bool isFiltering;
  final Function() onTap;

  EntryResetFilterButton(this.isFiltering, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        height: isFiltering ? 50 : 0,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        child: CustomButton("title_reset_filter".tr, Colors.red),
      ),
    );
  }
}
