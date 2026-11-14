// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller & Model
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';

// Used Widgets
import 'package:flutter_general_reviewer/modules/shared/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/change_category_selector.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';

// A dialog menu for both Update and Create usage for Categories
// If toUpdateCategory is given it will get the values from the category
Future<void> showCategoryDialog<T extends CategoryController>(
  String label,
  String hintText, {
  AppCategory? toUpdateCategory,
}) async {
  final controller = Get.find<T>();
  final bool isEditing = (toUpdateCategory != null);

  controller.initCategoryForm(toUpdateCategory);

  await AlertDialogBase.show(
    isEditing: isEditing,
    label: label,
    onSubmit: controller.saveCategory,
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
      // Category Name
      CustomTextField(
        labelText: '$label Name',
        hintText: 'e.g., $hintText',
        onChanged: (value) => controller.categoryName.value = value,
        initialValue: controller.categoryName.value,
      ),

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
  );
}
