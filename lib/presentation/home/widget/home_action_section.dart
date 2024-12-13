import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeActionSection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeActionSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomAction(
          widget: Icon(viewModel.ledgerOperation
              ? Icons.account_balance_wallet_rounded
              : Icons.attach_money_rounded),
          text: viewModel.ledgerOperation ? "label_icon_income".tr : "label_icon_expense".tr,
          onTap: () => viewModel.toggle(),
        ),
        CustomAction(
          widget: Image.asset(
            "asset/flag/${viewModel.selectedLanguage == "en" ? "kh.png" : "en.png"}",
            width: 20,
            height: 24,
          ),
          text: "label_icon_language".tr,
          onTap: () => viewModel.changeLanguage(),
        ),
      ],
    );
  }
}
