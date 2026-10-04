import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:get/get.dart';

void showAddCategoryDialog(
  BuildContext context, {
  AppCategory? toUpdateCategory,
}) {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<CategoryController>();

  final nameController = TextEditingController(
    text: toUpdateCategory?.name ?? '',
  );

  final Rx<Color> selectedColor = (toUpdateCategory != null)
      ? toUpdateCategory.getColor.obs
      : const Color(0xff443a49).obs;

  final bool isEditing = (toUpdateCategory != null);

  Get.dialog(
    AlertDialog(
      title: Text(isEditing ? 'Update Category' : 'Add New Category'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextFormField(
                controller: nameController,
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
              ),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Obx(
                () => ColorPicker(
                  color: selectedColor.value,
                  onColorChanged: (Color newColor) {
                    selectedColor.value = newColor;
                  },
                  wheelDiameter: 250,
                  enableShadesSelection: true,
                  pickersEnabled: const {
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.wheel: true,
                  },
                ),
              ),
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

        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      // Unfocus keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      final String newCategoryName = nameController.text.trim();
                      final String selectedColorHex = selectedColor.value.hex;

                      // Dismiss dialog explicitly
                      Navigator.of(context).pop();

                      if (isEditing) {
                        final updatedCategory = AppCategory(
                          id: toUpdateCategory.id,
                          name: newCategoryName,
                          color: selectedColorHex,
                        );
                        
                        await controller.updateCategory(updatedCategory);
                      } else {
                        
                        final newCategory = AppCategory(
                          name: newCategoryName,
                          color: selectedColorHex,
                        );
                        await controller.addCategory(newCategory);
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
        ),
      ],
    ),
    barrierDismissible: true,
  ).then((_) {
    // Safely dispose text controller after dialog closes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
    });
  });
}
