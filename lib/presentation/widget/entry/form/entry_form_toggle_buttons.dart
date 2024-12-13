import 'package:flutter/material.dart';

class EntryFormToggleButtons extends StatefulWidget {
  final List<bool> isSelected;
  final Function(int) onSelected;

  EntryFormToggleButtons(this.isSelected, this.onSelected);

  @override
  State<EntryFormToggleButtons> createState() => _EntryFormToggleButtonsState();
}

class _EntryFormToggleButtonsState extends State<EntryFormToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      fillColor: Colors.blue,
      selectedColor: Colors.white,
      children: [
        Text("៛", style: TextStyle(fontSize: 24)),
        Text("\$", style: TextStyle(fontSize: 24)),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < widget.isSelected.length; i++) {
            widget.isSelected[i] = i == index;
            widget.onSelected(index);
          }
        });
      },
      isSelected: widget.isSelected,
    );
  }
}
