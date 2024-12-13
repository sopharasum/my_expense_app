import 'package:flutter/material.dart';

class EntryFormTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool? isInteractiveSelection;
  final bool? isReadOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool isError;
  final String labelMsg;
  final String errorMsg;

  EntryFormTextFormField({
    required this.controller,
    required this.keyboardType,
    this.isInteractiveSelection,
    this.isReadOnly,
    this.onTap,
    this.onChanged,
    required this.isError,
    required this.labelMsg,
    required this.errorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      enableInteractiveSelection: isInteractiveSelection ?? true,
      readOnly: isReadOnly ?? false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelMsg,
        errorText: isError ? errorMsg : null,
      ),
    );
  }
}
