import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for reviewies
// If toUpdateReview is given it will get the values from the status
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showStatusDialog(
  BuildContext context, {
  MediaStatus? toUpdateStatus,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<StatusController>();

  final bool isEditing = (toUpdateStatus != null);

  final theme = Theme.of(context);

  controller.initStatusForm(toUpdateStatus);

  await Get.dialog(
    AlertDialog(
      surfaceTintColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,

      title: Text(isEditing ? 'Update Status' : 'Add New Status'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // Status Content
              _buildStatusNameField(controller),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Status color
              _buildColorPicker(controller),
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
          child: Text("Cancel"),
        ),

        _buildConfirmationButton(controller, formKey, context, isEditing),
      ],
    ),
  );
}

TextFormField _buildStatusNameField(StatusController controller) {
  return TextFormField(
    initialValue: controller.statusName.value,
    onChanged: (value) => controller.statusName.value = value,

    decoration: const InputDecoration(
      labelText: 'Status Name',
      hintText: 'e.g., Completed, Plan To Watch, Dropped',
      border: OutlineInputBorder(),
    ),

    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please Enter A Status Name";
      }
      return null;
    },
  );
}

Obx _buildColorPicker(StatusController controller) {
  return Obx(
    () => ColorPicker(
      color: controller.statusColor.value,
      onColorChanged: (Color newColor) {
        controller.statusColor.value = newColor;
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
  StatusController controller,
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
                  await controller.updateStatus();
                } else {
                  // New status Creatio
                  await controller.addStatus();
                }
              }
            },
      child: controller.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(isEditing ? 'Update' : 'Create'),
    ),
  );
}
