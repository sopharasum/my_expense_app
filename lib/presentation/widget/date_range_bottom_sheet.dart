import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/domain/entities/date_range.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeBottomSheet {
  final ThemeService _themeService = Get.find();

  void show(BuildContext context, Function(DateRange) onSelected) {
    final List<DateRange> items = [
      DateRange(
        label: "label_last_7_days".tr,
        start: _generateLastDays(7),
        end: _generateLastDays(7, start: false),
      ),
      DateRange(
        label: "label_last_30_days".tr,
        start: _generateLastDays(30),
        end: _generateLastDays(30, start: false),
      ),
      DateRange(
        label: "label_last_60_days".tr,
        start: _generateLastDays(60),
        end: _generateLastDays(60, start: false),
      ),
      DateRange(
        label: "label_last_90_days".tr,
        start: _generateLastDays(90),
        end: _generateLastDays(90, start: false),
      ),
      DateRange(
        label: "label_last_180_days".tr,
        start: _generateLastDays(180),
        end: _generateLastDays(180, start: false),
      ),
      DateRange(
        label: "label_custom_date_range".tr,
        start: "",
        end: "",
        isCustom: true,
      ),
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FutureBuilder(
          future: _themeService.loadThemeFromPref(),
          builder: (context, snapshot) {
            final isDarkMode = snapshot.data != null && snapshot.data == true;
            return Container(
              height: Get.height * 0.39,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withOpacity(.3)
                            : Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: CustomText(
                      text: "title_period_of_record".tr,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onSelected(items[index]);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: items[index].label,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        color: isDarkMode ? Colors.white : Colors.blue,
                      ),
                      itemCount: items.length,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _generateLastDays(int days, {bool? start = true}) {
    final now = new DateTime.now();
    final lastDays = now.subtract(Duration(days: days));
    return start == true
        ? EntryUtil.getStartDay(lastDays)
        : EntryUtil.getEndDay(now);
  }
}
