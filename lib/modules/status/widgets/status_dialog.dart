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
              TextFormField(
                initialValue: controller.statusName.value,
                onChanged: (value) => controller.statusName.value = value,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter A Status";
                  }
                  return null;
                },
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

                      // Dismiss dialog explicitly
                      // Can not use Get.Back() cause it is cauisng problem with the Success Snackbar
                      Navigator.of(context).pop();

                      if (isEditing) {
                        await controller.updateStatus();
                      } else {
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
                : Text(isEditing ? 'Update' : 'Add'),
          ),
        ),
      ],
    ),
  );
}
