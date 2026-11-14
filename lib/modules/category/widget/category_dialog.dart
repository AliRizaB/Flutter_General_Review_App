import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/change_category_selector.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for Categories
// If toUpdateCategory is given it will get the values from the category
Future<void> showCategoryDialog<T extends CategoryController>(
  String label,
  String hintText,
  BuildContext context, {
  AppCategory? toUpdateCategory,
}) async {
  final controller = Get.find<T>();
  final bool isEditing = (toUpdateCategory != null);

  controller.initCategoryForm(toUpdateCategory);

  await Get.dialog(
    AlertDialogBase(
      isEditing: isEditing,
      label: label,

      onSubmit: () async {
        if (isEditing) {
          await controller.updateCategory();
        } else {
          await controller.addCategory();
        }
      },
      children: [
        ChangeCategorySelector<AppCategory>(
          isEdit: isEditing && controller.canEditParentCategory,
          listValues: controller.parentCategories,
          selectedId: controller.categoryParentId.value,
          getItemId: (subCategory) => subCategory.id,
          getItemLabel: (subCategory) => subCategory.name,
          onChanged: (int? newId) {
            if (newId != null) {
              controller.categoryParentId.value = newId;
            }
          },
        ),
        const SizedBox(height: 12),
        // Category Name
        CustomTextField(
          labelText: '$label Name',
          hintText: 'e.g., $hintText',
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
