import 'package:expense_app/domain/entities/day_of_week.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryFormVisibilityDay extends StatefulWidget {
  final List<DayOfWeek> dayOfWeek;
  final String language;
  final bool isDarkMode;
  final bool? isRecurring;

  EntryFormVisibilityDay({
    required this.dayOfWeek,
    required this.language,
    required this.isDarkMode,
    this.isRecurring,
  });

  @override
  State<EntryFormVisibilityDay> createState() => _EntryFormVisibilityDayState();
}

class _EntryFormVisibilityDayState extends State<EntryFormVisibilityDay> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isRecurring == true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "label_recurring_select_day".tr, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              widget.dayOfWeek.length,
              (index) => GestureDetector(
                onTap: () => setState(() {
                  widget.dayOfWeek[index].selected =
                      !widget.dayOfWeek[index].selected!;
                }),
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width * .12,
                  height: Get.height * .08,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dayOfWeek[index].selected == true
                        ? widget.isDarkMode
                            ? Colors.white
                            : Colors.blue
                        : Colors.transparent,
                    border: Border.all(
                        color: widget.isDarkMode ? Colors.white : Colors.blue),
                  ),
                  child: CustomText(
                    text: widget.language == "km"
                        ? widget.dayOfWeek[index].kh[0]
                        : widget.dayOfWeek[index].en[0],
                    fontSize: 20,
                    color: widget.dayOfWeek[index].selected == true
                        ? widget.isDarkMode
                            ? Colors.blue
                            : Colors.white
                        : widget.isDarkMode
                            ? Colors.white
                            : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
