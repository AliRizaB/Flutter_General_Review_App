import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.initialValue,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),

      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
    );
  }
}
