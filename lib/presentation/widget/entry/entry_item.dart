import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/app_dialog.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;
  final bool isDarkMode;
  final String language;
  final Function(Entry) onSelected;
  final Function(Entry) onDeleted;

  EntryItem(
    this.entry,
    this.isDarkMode,
    this.language,
    this.onSelected,
    this.onDeleted,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => AppDialog().showConfirm(
        context,
        "msg_delete_expense_title".tr,
        "msg_delete_expense".tr,
        () => onDeleted(entry),
      ),
      onTap: () => onSelected(entry),
      child: Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              entry.entryRemark?.isNotEmpty == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "${entry.entryRemark}",
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          text: " - ${entry.entryCategory?.categoryName}",
                          color: isDarkMode
                              ? Colors.white.withOpacity(.8)
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ],
                    )
                  : CustomText(
                      text: "${entry.entryCategory?.categoryName}",
                      fontWeight: FontWeight.bold,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: EntryUtil.showDateTime(
                      language,
                      entry.entryDateTime,
                    ),
                    color:
                        isDarkMode ? Colors.white.withOpacity(.8) : Colors.grey,
                    fontSize: 13,
                  ),
                  CustomText(
                    text: "${EntryUtil.getCurrency(
                      entry.entryCurrency,
                      entry.entryAmount,
                    )}",
                    color: Colors.red,
                    fontSize: 15,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
