import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;

  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,

    this.onChanged,
    this.onSaved,
    this.validator,

    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
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
      onSaved: onSaved,

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),

      style: const TextStyle(fontFamily: null),

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
