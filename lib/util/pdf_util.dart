import 'dart:io';

import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/config/khmer_date.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PDFUtil {
  void htmlToPdf({
    required bool isYearly,
    required DateTime dateTime,
    required bool ledgerReport,
    required List<Entry> ledgers,
    required List<Entry> incomes,
    required Function(String) onShare,
  }) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final customFont = "siemreap_regular";
    if (!File('${appDirectory.path}/$customFont.ttf').existsSync()) {
      final File fontFile = File('${appDirectory.path}/$customFont.ttf');
      final content =
          await rootBundle.load('asset/font/Siemreap/$customFont.ttf');
      fontFile.writeAsBytesSync(content.buffer.asUint8List());
    }
    final language = await getLanguage();
    final String month = language == "en"
        ? isYearly
            ? Formatter.fullYearFormat(dateTime)
            : Formatter.fullMonthYearFormat(dateTime)
        : KhmerDate.date(
            dateTime.toString(),
            format: isYearly ? "ឆ្នាំyyyy" : "ខែmmm ឆ្នាំyyyy",
          );

    final htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        @font-face {
        		font-family: "$customFont";
        		src: url('file:///${appDirectory.path}/$customFont.ttf')  format('truetype');
    		}
		
    		body {
        		font-size: 14px;
        		font-family: "$customFont";
        		margin: 0px;
    		}
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        .center {
            text-align: center;
        }
        .right {
            text-align: right;
        }
        </style>
      </head>
      <body>
        <div class="center">
          <h3>${ledgerReport ? "${"label_col_expense_report".tr}$month" : "${"label_col_income_report".tr}$month"}</h3>
        </div>
        <table style="width:100%">
            <tr>
                <th class="center"><b>${"label_col_no".tr}</b></th>
                <th class="center"><b>${"label_col_date".tr}</b></th>
                <th class="center"><b>${"label_col_category".tr}</b></th>
                <th class="center"><b>${"label_col_desc".tr}</b></th>
                <th class="center" colspan="2"><b>${ledgerReport ? "label_icon_expense".tr : "label_icon_income".tr}</b></th>
            </tr>
            """ +
        generateList(
            language: language,
            ledgerReport: ledgerReport,
            ledgers: ledgers,
            incomes: incomes) +
        """
            <tr>
                <td colspan="4" class="right"><b>${"label_sub_total".tr}</b></td>
                <td class="right"><b>${Formatter.formatCurrency((ledgerReport ? EntryUtil.calculateGrandTotal(ledgers, "KHR") : EntryUtil.calculateGrandTotal(incomes, "KHR")))} ៛</b></td>
                <td class="right"><b>${(ledgerReport ? EntryUtil.calculateGrandTotal(ledgers, "USD") : EntryUtil.calculateGrandTotal(incomes, "USD")).toStringAsFixed(2)} \$</b></td>
            </tr>
            <tr>
                <td colspan="4" class="right"><b>${"label_in_khmer_riel".tr}</b></td>
                <td colspan="2" class="right"><b>${Formatter.formatCurrency((ledgerReport ? EntryUtil.grandTotalInCurrency(ledgers, "KHR") : EntryUtil.grandTotalInCurrency(incomes, "KHR")))} ៛</b></td>
            </tr>
            <tr>
                <td colspan="4" class="right"><b>${"label_in_us_dollar".tr}</b></td>
                <td colspan="2" class="right"><b>${(ledgerReport ? EntryUtil.grandTotalInCurrency(ledgers, "USD") : EntryUtil.grandTotalInCurrency(incomes, "USD")).toStringAsFixed(2)} \$</b></td>
            </tr>
        </table>
        <div class="right"><span style="font-style: italic; color: #ff0000;">${"label_exchange_rate".tr}</span></div>
        <div style="width: 100%;position:relative;display: inline-block;text-align: center;">
        <div style="width: 30%;padding: 0 12px;text-align: center;margin: 0 auto;">
            <hr/>
            <div style="margin-top: -24px;"><span style="background: white;padding: 0 12px;">${"label_end_of_report".tr}</span></div>
        </div>
    </div>
      </body>
    </html>
    """;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final String type = ledgerReport ? "Expense" : "Income";
    final String targetFileName =
        "${Formatter.yearMonthFormat(dateTime)}-$type-Report";
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    onShare.call(generatedPdfFile.path);
  }

  String generateList({
    required String language,
    required bool ledgerReport,
    required List<Entry> ledgers,
    required List<Entry> incomes,
  }) {
    ledgers.sort(
      (a, b) => a.entryDateTime!.compareTo(b.entryDateTime.toString()),
    );
    incomes.sort(
      (a, b) => a.entryDateTime!.compareTo(b.entryDateTime.toString()),
    );
    var content = "";
    for (int index = 0;
        index < (ledgerReport ? ledgers.length : incomes.length);
        index++) {
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
      content += """<tr>
                <td class="center">${index + 1}</td>
                <td class="center">$dateTime</td>
                <td>${ledgerReport ? ledgers[index].entryCategory?.categoryName : incomes[index].entryCategory?.categoryName}</td>
                <td>${ledgerReport ? ledgers[index].entryRemark ?? "-" : incomes[index].entryRemark ?? "-"}</td>
                <td class="right">${(ledgerReport ? ledgers[index].entryCurrency : incomes[index].entryCurrency) == "KHR" ? "${Formatter.formatCurrency((ledgerReport ? ledgers[index].entryAmount : incomes[index].entryAmount))} ៛" : "-"}</td>
                <td class="right">${(ledgerReport ? ledgers[index].entryCurrency : incomes[index].entryCurrency) == "USD" ? "${(ledgerReport ? ledgers[index].entryAmount : incomes[index].entryAmount)} \$" : "-"}</td>
            </tr>""";
    }
    return content;
  }
}
