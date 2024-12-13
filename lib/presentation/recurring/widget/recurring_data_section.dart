import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/presentation/recurring/recurring_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecurringDataSection extends StatelessWidget {
  final RecurringViewModel viewModel;

  RecurringDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => viewModel.refreshData(),
        child: CustomScrollView(
          controller: viewModel.scroll,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RecurringItem(
                    viewModel,
                    viewModel.recurrences[index],
                    (item) => viewModel.delete(item),
                  ),
                  childCount: viewModel.recurrences.length,
                ),
              ),
            ),
            viewModel.queryStatus == DataStatus.QUERY_MORE
                ? CustomLoading()
                : CustomEmptyContainer()
          ],
        ),
      ),
    );
  }
}

class RecurringItem extends StatelessWidget {
  final RecurringViewModel viewModel;
  final Recurring item;
  final Function(Recurring) onLongPressed;

  RecurringItem(this.viewModel, this.item, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => viewModel.navigateToForm(item),
      onLongPress: () => AppDialog().showConfirm(
        context,
        "title_delete_recurring".tr,
        "msg_delete_recurring".tr,
        () => onLongPressed.call(item),
      ),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.recurringRemark.isNotEmpty)
                _buildText(
                    "label_recurring_description".tr, item.recurringRemark),
              _buildText("label_recurring_price".tr, viewModel.getPrice(item)),
              _buildText(
                  "label_recurring_category".tr, item.category?.categoryName),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    CustomText(
                      text: "label_recurring_every_day".tr,
                      fontSize: 13,
                    ),
                    Row(
                      children: viewModel
                          .getScheduledDay(item)
                          .map((day) => day.selected == true
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: CustomText(
                                    text: viewModel.language == "en"
                                        ? day.en
                                        : day.kh,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : SizedBox())
                          .toList(),
                    )
                  ],
                ),
              ),
              _buildText(
                "label_recurring_start_day".tr,
                viewModel.getStartDate(item.recurringCreatedDate),
              ),
              _buildText(
                "label_recurring_every_time".tr,
                viewModel.getTime(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String label, String? value) {
    return Text.rich(
      TextSpan(
          text: "$label ",
          children: [
            TextSpan(
              text: value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
          style: TextStyle(fontSize: 13)),
    );
  }
}
