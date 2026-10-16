import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/category/widget/add_category_widgets/color_picker.dart';
import 'package:flutter_general_reviewer/modules/category/widget/add_category_widgets/name_field.dart';
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
              buildCategoryNameField(controller),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Category color
              buildColorPicker(controller),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
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

Obx _buildConfirmationButton(
  CategoryController controller,
  GlobalKey<FormState> formKey,
  BuildContext context,
  bool isEditing,
) {
  return Obx(
    () => ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(Get.context!).colorScheme.primary,
          width: 2, // Border width
        ),
      ),
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
