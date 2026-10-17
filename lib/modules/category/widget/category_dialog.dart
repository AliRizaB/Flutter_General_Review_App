import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for Categories
// If toUpdateCategory is given it will get the values from the category
Future<void> showCategoryDialog(
  BuildContext context, {
  AppCategory? toUpdateCategory,
}) async {
  final controller = Get.find<CategoryController>();
  final bool isEditing = (toUpdateCategory != null);

  controller.initCategoryForm(toUpdateCategory);

  await Get.dialog(
    AlertDialogBase(
      isEditing: isEditing,
      label: 'Category',

      onSubmit: () async {
        if (isEditing) {
          await controller.updateCategory();
        } else {
          await controller.addCategory();
        }
      },
      children: [
        // Category Name
        CustomTextField(
          labelText: 'Category Name',
          hintText: 'e.g., Movies, Books, Games',
          onChanged: (value) => controller.categoryName.value = value,
          initialValue: controller.categoryName.value,
        ),

        const SizedBox(height: 16),

        // Category color
        Obx(
          () => ColorPickerField(
            initialColor: controller.categoryColor.value,
            onColorChanged: (Color newColor) {
              controller.categoryColor.value = newColor;
            },
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
