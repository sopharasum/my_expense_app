import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/date_range.dart';
import 'package:expense_app/presentation/widget/date_range_bottom_sheet.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryDateSelector extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(DateRange) onSelected;

  EntryDateSelector(this.controller, this.hint, this.onSelected);

  @override
  Widget build(BuildContext context) {
    final dateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );
    return Expanded(
      child: TextFormField(
        onTap: () => DateRangeBottomSheet().show(
          context,
          (data) => data.isCustom == true
              ? pickDateRange(context, dateRange, (data) => onSelected(data))
              : onSelected(data),
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
    );
  }

  Future pickDateRange(
    BuildContext context,
    DateTimeRange dateRange,
    Function(DateRange) onSelected,
  ) async {
    final language = await getLanguage();
    final newDateRange = await showDateRangePicker(
      context: context,
      locale: Locale(language, language == "km" ? 'KH' : 'US'),
      initialEntryMode: DatePickerEntryMode.input,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (newDateRange == null) return;
    final range = DateRange(
      label: "label_custom_date_range".tr,
      start: EntryUtil.getStartDay(newDateRange.start),
      end: EntryUtil.getEndDay(newDateRange.end),
    );
    onSelected(range);
  }
}
