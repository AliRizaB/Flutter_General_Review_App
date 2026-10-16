import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';

TextFormField buildContentField(ReviewController controller) {
  return TextFormField(
    initialValue: controller.content.value,
    onChanged: (value) => controller.content.value = value,
    maxLines: 5,
    decoration: const InputDecoration(
      labelText: 'Review',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please Enter A Review";
      }
      return null;
    },
  );
}
