import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for Categories
// If toUpdateCategory is given it will get the values from the category
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showAddCategoryDialog(
  BuildContext context, {
  AppCategory? toUpdateCategory,
}) async {
  final theme = Theme.of(context);
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<CategoryController>();

  final bool isEditing = (toUpdateCategory != null);

  controller.initCategoryForm(toUpdateCategory);

  await Get.dialog(
    AlertDialog(
      // Theme
      surfaceTintColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,

      title: Text(isEditing ? 'Update Category' : 'Add New Category'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // Category Name
              _buildCategoryNameField(controller),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Category color
              _buildColorPicker(controller),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),

        _buildConfirmationButton(controller, formKey, context, isEditing),
      ],
    ),
    barrierDismissible: true,
  );
}

TextFormField _buildCategoryNameField(CategoryController controller) {
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

Obx _buildColorPicker(CategoryController controller) {
  return Obx(
    () => ColorPicker(
      color: controller.categoryColor.value,
      onColorChanged: (Color newColor) {
        controller.categoryColor.value = newColor;
      },
      wheelDiameter: 250,
      enableShadesSelection: true,
      pickersEnabled: const {
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
    ),
  );
}

Obx _buildConfirmationButton(
  CategoryController controller,
  GlobalKey<FormState> formKey,
  BuildContext context,
  bool isEditing,
) {
  return Obx(
    () => ElevatedButton(
      onPressed: controller.isLoading
          ? null
          : () async {
              if (formKey.currentState!.validate()) {
                // Unfocus keyboard
                FocusManager.instance.primaryFocus?.unfocus();

                // Dismiss dialog explicitly
                // Can not use Get.Back() cause it is cauisng problem with the Success Snackbar
                Navigator.of(context).pop();

                if (isEditing) {
                  await controller.updateCategory();
                } else {
                  // New category Creatio
                  await controller.addCategory();
                }
              }
            },
      child: controller.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(isEditing ? 'Update' : 'Add'),
    ),
  );
}
