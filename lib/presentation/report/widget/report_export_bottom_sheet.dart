import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ExportType { pdf, excel, none }

class ReportExportBottomSheet {
  final ThemeService _themeService = Get.find();

  void show({
    required BuildContext context,
    required Function(ExportType?) onSelectedType,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        ExportType? _type = ExportType.none;
        return FutureBuilder(
            future: _themeService.loadThemeFromPref(),
            builder: (context, snapshot) {
              final isDarkMode = snapshot.data != null && snapshot.data == true;
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: Get.height * .25,
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
                            text: "label_select_file_type".tr,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        ReportExportItem(
                          isDarkMode: isDarkMode,
                          icon: "asset/icon/pdf.png",
                          value: ExportType.pdf,
                          groupValue: _type,
                          label: "PDF",
                          onChanged: (value) => setState(() {
                            _type = value;
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pop(context);
                              onSelectedType.call(_type);
                            });
                          }),
                        ),
                        ReportExportItem(
                          isDarkMode: isDarkMode,
                          icon: "asset/icon/excel.png",
                          value: ExportType.excel,
                          groupValue: _type,
                          label: "Excel",
                          onChanged: (value) => setState(() {
                            _type = value;
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pop(context);
                              onSelectedType.call(_type);
                            });
                          }),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
      },
    );
  }
}

class ReportExportItem extends StatelessWidget {
  final bool isDarkMode;
  final String icon;
  final ExportType value;
  final ExportType? groupValue;
  final String label;
  final Function(ExportType?) onChanged;

  const ReportExportItem({
    Key? key,
    required this.isDarkMode,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: isDarkMode ? Colors.black.withOpacity(.3) : Colors.black12,
      ),
      child: RadioListTile<ExportType>(
        controlAffinity: ListTileControlAffinity.trailing,
        title: Row(
          children: [
            Image.asset(icon, width: 36, height: 36),
            SizedBox(width: 17),
            CustomText(text: label),
          ],
        ),
        value: value,
        groupValue: groupValue,
        onChanged: (value) => onChanged.call(value),
      ),
    );
  }
}
