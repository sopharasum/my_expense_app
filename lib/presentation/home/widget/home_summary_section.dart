import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSummarySection extends StatelessWidget {
  final HomeViewModel viewModel;

  HomeSummarySection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(12),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SummarySectionText(
              Colors.red,
              "${"label_khr_currency".tr}",
              Formatter.formatCurrency(viewModel.totalKHR),
              false,
            ),
            SummarySectionText(
              Colors.blue,
              "${"label_usd_currency".tr}",
              viewModel.totalUSD.toString(),
              true,
            )
          ],
        ),
      ),
    );
  }
}

class SummarySectionText extends StatelessWidget {
  final Color color;
  final String title;
  final String data;
  final bool isRightRadius;

  SummarySectionText(this.color, this.title, this.data, this.isRightRadius);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: isRightRadius ? Radius.circular(0) : Radius.circular(12),
            bottomLeft:
                isRightRadius ? Radius.circular(0) : Radius.circular(12),
            topRight: isRightRadius ? Radius.circular(12) : Radius.circular(0),
            bottomRight:
                isRightRadius ? Radius.circular(12) : Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            CustomText(
              textAlign: TextAlign.center,
              text: title,
              color: Colors.white,
              fontSize: 16,
            ),
            SizedBox(height: 4),
            CustomText(
              textAlign: TextAlign.center,
              text: data,
              color: Colors.white,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
