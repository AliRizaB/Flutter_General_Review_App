import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_form.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/form_cancel_button.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/form_submit_button.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for Categories
// If toUpdateCategory is given it will get the values from the category
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showCategoryDialog(
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
              CustomTextField(
                labelText: 'Category Name',
                hintText: 'e.g., Movies, Books, Games',
                onChanged: (value) => controller.categoryName.value = value,
                initialValue: controller.categoryName.value,
              ),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Category color
              ColorPickerField(
                initialColor: controller.categoryColor.value,
                onColorChanged: (Color newColor) {
                  controller.categoryColor.value = newColor;
                },
              ),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FormCancelButton(),

        FormSubmitButton(
          formKey: formKey,
          isEditing: isEditing,
          onSubmit: () => isEditing
              ? controller.updateCategory()
              : controller.addCategory(),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
