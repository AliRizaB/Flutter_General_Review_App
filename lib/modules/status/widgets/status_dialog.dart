import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_dialog_widgets/build_color_picker.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/form_submit_button.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_dialog_widgets/build_name_field.dart';
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
              buildStatusNameField(controller),

              const SizedBox(height: 16),

              const Text(
                'Pick Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Status color
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
          child: Text("Cancel"),
        ),

        FormSubmitButton(
          formKey: formKey,
          isEditing: isEditing,
          onSubmit: () =>
              isEditing ? controller.updateStatus() : controller.addStatus(),
        ),
      ],
    ),
  );
}
