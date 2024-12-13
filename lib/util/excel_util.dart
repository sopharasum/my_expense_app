import 'dart:io';

import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/config/khmer_date.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelUtil {
  Future<void> createExcel({
    required bool isYearly,
    required DateTime dateTime,
    required bool ledgerReport,
    required List<Entry> ledgers,
    required List<Entry> incomes,
    required Function(String) onShare,
  }) async {
    final language = await getLanguage();
    final String month = language == "en"
        ? isYearly
            ? Formatter.fullYearFormat(dateTime)
            : Formatter.fullMonthYearFormat(dateTime)
        : KhmerDate.date(
            dateTime.toString(),
            format: isYearly ? "ឆ្នាំyyyy" : "ខែmmm ឆ្នាំyyyy",
          );
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Range headerRange = sheet.getRangeByName("A1:F1");
    headerRange.merge();
    headerRange.cellStyle.fontSize = 12;
    headerRange.cellStyle.hAlign = HAlignType.center;
    headerRange.cellStyle.vAlign = VAlignType.center;
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.borders.all.lineStyle = LineStyle.thin;
    headerRange.cellStyle.borders.all.color = '#000000';
    headerRange.autoFit();
    headerRange.setText(
      ledgerReport
          ? "${"label_col_expense_report".tr}$month"
          : "${"label_col_income_report".tr}$month",
    );

    final Range columnRange = sheet.getRangeByName("A2:F2");
    columnRange.cellStyle.fontSize = 11;
    columnRange.cellStyle.hAlign = HAlignType.center;
    columnRange.cellStyle.vAlign = VAlignType.center;
    columnRange.cellStyle.bold = true;
    columnRange.cellStyle.borders.all.lineStyle = LineStyle.thin;
    columnRange.cellStyle.borders.all.color = '#000000';

    sheet.getRangeByName("A2").setText("label_col_no".tr);
    sheet.getRangeByName("B2").setText("label_col_date".tr);
    sheet.getRangeByName("C2").setText("label_col_category".tr);
    sheet.getRangeByName("D2").setText("label_col_desc".tr);
    sheet.getRangeByName("E2:F2").merge();
    sheet.getRangeByName("E2:F2").setText(
        ledgerReport ? "label_icon_expense".tr : "label_icon_income".tr);
    // sheet.getRangeByName("F2").setText("label_total_as_usd".tr);

    if ((ledgerReport ? ledgers.isNotEmpty : incomes.isNotEmpty)) {
      incomes.sort(
        (a, b) => a.entryDateTime!.compareTo(
          b.entryDateTime.toString(),
        ),
      );
      ledgers.sort(
        (a, b) => a.entryDateTime!.compareTo(
          b.entryDateTime.toString(),
        ),
      );
      int rowIndex = 3;
      for (int index = 0;
          index < (ledgerReport ? ledgers.length : incomes.length);
          index++) {
        index == 0 ? rowIndex = rowIndex : rowIndex = rowIndex + 1;
        //No. Column
        sheet.getRangeByName("A$rowIndex").setText("${index + 1}");
        sheet.getRangeByName("A$rowIndex").cellStyle.vAlign = VAlignType.center;
        sheet.getRangeByName("A$rowIndex").cellStyle.hAlign = HAlignType.center;
        sheet.getRangeByName("A$rowIndex").cellStyle.borders.all.lineStyle =
            LineStyle.thin;
        sheet.getRangeByName("A$rowIndex").cellStyle.borders.all.color =
            '#000000';
        sheet.getRangeByName("A$rowIndex").autoFit();

        //Date/Time Column
        final dateTime = language == "en"
          ? Formatter.dateHourFormat(
              ledgerReport
                  ? ledgers[index].entryDateTime
                  : incomes[index].entryDateTime,
            )
          : KhmerDate.date(
              Formatter.dateToStringLocal(
                ledgerReport
                    ? ledgers[index].entryDateTime ?? ""
                    : incomes[index].entryDateTime ?? "",
              ),
              format: "dd mmm yyyy ម៉ោង Hr",
            );
        _generateTextSheet(sheet, "B$rowIndex", dateTime);

        //Category Column
        _generateTextSheet(
          sheet,
          "C$rowIndex",
          "${ledgerReport ? ledgers[index].entryCategory?.categoryName : incomes[index].entryCategory?.categoryName}",
        );

        //Remark Column
        _generateTextSheet(
          sheet,
          "D$rowIndex",
          "${ledgerReport ? ledgers[index].entryRemark ?? "-" : incomes[index].entryRemark ?? "-"}",
        );

        //KHR Column
        _generateAmountSheet(
          sheet,
          "E$rowIndex",
          "${(ledgerReport ? ledgers[index].entryCurrency : incomes[index].entryCurrency) == "KHR" ? "${Formatter.formatCurrency((ledgerReport ? ledgers[index].entryAmount : incomes[index].entryAmount))} ៛" : "-"}",
        );

        //USD Column
        _generateAmountSheet(
          sheet,
          "F$rowIndex",
          "${(ledgerReport ? ledgers[index].entryCurrency : incomes[index].entryCurrency) == "USD" ? "${(ledgerReport ? ledgers[index].entryAmount : incomes[index].entryAmount)} \$" : "-"}",
        );
      }
      //Subtotal Row
      _generateSubtotalCol(sheet, rowIndex + 1, "label_sub_total".tr);
      _generateSubtotalSheet(
        sheet,
        "E${rowIndex + 1}",
        "${Formatter.formatCurrency((ledgerReport ? EntryUtil.calculateGrandTotal(ledgers, "KHR") : EntryUtil.calculateGrandTotal(incomes, "KHR")))} ៛",
      );
      _generateSubtotalSheet(
        sheet,
        "F${rowIndex + 1}",
        "${(ledgerReport ? EntryUtil.calculateGrandTotal(ledgers, "USD") : EntryUtil.calculateGrandTotal(incomes, "USD")).toStringAsFixed(2)} \$",
      );

      //KHR Grand Total Row
      _generateSubtotalCol(sheet, rowIndex + 2, "label_in_khmer_riel".tr);
      _generateGrandTotalCol(
        sheet,
        rowIndex + 2,
        "${Formatter.formatCurrency((ledgerReport ? EntryUtil.grandTotalInCurrency(ledgers, "KHR") : EntryUtil.grandTotalInCurrency(incomes, "KHR")))} ៛",
      );

      //USD Grand Total Row
      _generateSubtotalCol(sheet, rowIndex + 3, "label_in_us_dollar".tr);
      _generateGrandTotalCol(
        sheet,
        rowIndex + 3,
        "${(ledgerReport ? EntryUtil.grandTotalInCurrency(ledgers, "USD") : EntryUtil.grandTotalInCurrency(incomes, "USD")).toStringAsFixed(2)} \$",
      );
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String type = ledgerReport ? "Expense" : "Income";
    final String fileName =
        "$path/${Formatter.yearMonthFormat(dateTime)}-$type-Report.xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    onShare.call(fileName);
  }

  void _generateTextSheet(Worksheet sheet, String column, String data) {
    final textSheet = sheet.getRangeByName(column);
    textSheet.setText(data);
    textSheet.cellStyle.vAlign = VAlignType.center;
    textSheet.autoFit();
    textSheet.cellStyle.borders.all.lineStyle = LineStyle.thin;
    textSheet.cellStyle.borders.all.color = '#000000';
  }

  void _generateAmountSheet(Worksheet sheet, String column, String amount) {
    final amountSheet = sheet.getRangeByName(column);
    amountSheet.setText(amount);
    amountSheet.numberFormat = '_(\$* #,##0_)';
    amountSheet.cellStyle.vAlign = VAlignType.center;
    amountSheet.cellStyle.hAlign = HAlignType.right;
    amountSheet.autoFit();
    amountSheet.cellStyle.borders.all.lineStyle = LineStyle.thin;
    amountSheet.cellStyle.borders.all.color = '#000000';
  }

  void _generateSubtotalSheet(
    Worksheet sheet,
    String column,
    String amount,
  ) {
    final subtotalSheet = sheet.getRangeByName(column);
    subtotalSheet.setText(amount);
    subtotalSheet.autoFit();
    subtotalSheet.cellStyle.vAlign = VAlignType.center;
    subtotalSheet.cellStyle.hAlign = HAlignType.right;
    subtotalSheet.cellStyle.bold = true;
    subtotalSheet.cellStyle.borders.all.lineStyle = LineStyle.thin;
    subtotalSheet.cellStyle.borders.all.color = '#000000';
  }

  void _generateSubtotalCol(Worksheet sheet, int rowIndex, String label) {
    final Range subtotalCol = sheet.getRangeByName("A$rowIndex:D$rowIndex");
    subtotalCol.merge();
    subtotalCol.cellStyle.vAlign = VAlignType.center;
    subtotalCol.cellStyle.hAlign = HAlignType.right;
    subtotalCol.cellStyle.bold = true;
    subtotalCol.cellStyle.borders.all.lineStyle = LineStyle.thin;
    subtotalCol.cellStyle.borders.all.color = '#000000';
    subtotalCol.setText(label);
  }

  void _generateGrandTotalCol(Worksheet sheet, int rowIndex, String label) {
    final Range grandTotalCol = sheet.getRangeByName("E$rowIndex:F$rowIndex");
    grandTotalCol.merge();
    grandTotalCol.cellStyle.vAlign = VAlignType.center;
    grandTotalCol.cellStyle.hAlign = HAlignType.right;
    grandTotalCol.cellStyle.bold = true;
    grandTotalCol.cellStyle.borders.all.lineStyle = LineStyle.thin;
    grandTotalCol.cellStyle.borders.all.color = '#000000';
    grandTotalCol.setText(label);
  }
}
