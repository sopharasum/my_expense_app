import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<TableRow> children;
  final double? rielColumn;
  final double? dollaColumn;

  CustomTable({required this.children, this.rielColumn, this.dollaColumn});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey.shade300),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(rielColumn ?? 70),
        2: FixedColumnWidth(dollaColumn ?? 80),
      },
      children: children,
    );
  }
}
