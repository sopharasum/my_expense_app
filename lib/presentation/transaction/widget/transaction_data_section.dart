import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/transaction.dart';
import 'package:expense_app/presentation/transaction/transaction_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDataSection extends StatelessWidget {
  final TransactionViewModel viewModel;

  TransactionDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => viewModel.reloadData(),
        child: CustomScrollView(
          controller: viewModel.scroll,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TransactionItem(
                        viewModel.isDarkMode,
                        viewModel.language,
                        viewModel.transactions[index],
                        (item) => viewModel.cancel(index, item));
                  },
                  childCount: viewModel.transactions.length,
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

class TransactionItem extends StatelessWidget {
  final bool isDarkMode;
  final String? language;
  final Transaction item;
  final Function(Transaction) onCancel;

  TransactionItem(this.isDarkMode, this.language, this.item, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.transactionStatus == "PENDING")
          AppDialog().showConfirm(
            context,
            "title_transaction_cancel".tr,
            "msg_transaction_cancel".tr,
            () => onCancel.call(item),
          );
      },
      child: Card(
        elevation: 1.5,
        child: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: item.transactionPlan.name,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    _buildInfo(
                      isDarkMode,
                      "label_transaction_price".tr,
                      "\$ ${item.transactionPrice.toStringAsFixed(2)}",
                    ),
                    _buildInfo(
                      isDarkMode,
                      "label_transaction_purchased".tr,
                      "${EntryUtil.showDate(language, item.transactionStart)}",
                    ),
                    _buildInfo(
                      isDarkMode,
                      "label_transaction_valid".tr,
                      "${EntryUtil.showDate(language, item.transactionEnd)}",
                    )
                  ],
                ),
              ),
              if (item.transactionStatus == "CANCEL" ||
                  item.transactionStatus == "INACTIVE" ||
                  item.transactionStatus == "EXPIRED")
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isDarkMode
                        ? Colors.black.withOpacity(.6)
                        : Colors.white.withOpacity(.6),
                  ),
                  height: Get.height * .141,
                ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: Get.width * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    color: item.transactionStatus == "PENDING" ||
                            item.transactionStatus == "EXPIRED"
                        ? Colors.grey
                        : item.transactionStatus == "INACTIVE" ||
                                item.transactionStatus == "CANCEL"
                            ? Colors.red
                            : Colors.blue,
                  ),
                  child: CustomText(
                    text: _getStatus(
                      language.toString(),
                      item.transactionStatus,
                    ),
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatus(String language, String status) {
    switch (status) {
      case "PENDING":
        return language == "km" ? "កំពុងពិនិត្យ" : status;
      case "ACTIVE":
        return language == "km" ? "ដំណើរការ" : status;
      case "INACTIVE":
        return language == "km" ? "មិនដំណើរការ" : status;
      case "CANCEL":
        return language == "km" ? "បោះបង់" : status;
      default:
        return language == "km" ? "ផុតសុពលភាព" : status;
    }
  }

  Widget _buildInfo(bool isDarkMode, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        children: [
          TextSpan(
            text: data,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          )
        ],
        style: TextStyle(
          fontFamily: "Siemreap",
          fontSize: 14,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
