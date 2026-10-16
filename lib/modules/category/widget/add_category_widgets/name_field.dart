import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';

TextFormField buildCategoryNameField(CategoryController controller) {
  return TextFormField(
    initialValue: controller.categoryName.value,
    onChanged: (value) => controller.categoryName.value = value,

    decoration: const InputDecoration(
      labelText: 'Category Name',
      hintText: 'e.g., Movies, Books, Games',
      border: OutlineInputBorder(),
    ),

    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please Enter A Category Name";
      }
      return null;
    },
  );
}