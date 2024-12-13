import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';

class EntryFormRepeatCheckBox extends StatefulWidget {
  final String label;
  final bool? isRecurring;
  final Function(bool?) onChanged;

  EntryFormRepeatCheckBox({
    required this.label,
    this.isRecurring,
    required this.onChanged,
  });

  @override
  State<EntryFormRepeatCheckBox> createState() =>
      _EntryFormRepeatCheckBoxState();
}

class _EntryFormRepeatCheckBoxState extends State<EntryFormRepeatCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CheckboxListTile(
        activeColor: Colors.blue,
        contentPadding: EdgeInsets.zero,
        value: widget.isRecurring,
        onChanged: (value) => widget.onChanged.call(value),
        title: CustomText(text: widget.label),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
