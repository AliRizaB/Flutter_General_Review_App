import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.initialValue,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.focusNode,
  }) : assert(
         initialValue == null || controller == null,
         'Cannot provide both an initialValue and a controller.',
       );
  // assertion if Both controller and initailValue given together

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,

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
