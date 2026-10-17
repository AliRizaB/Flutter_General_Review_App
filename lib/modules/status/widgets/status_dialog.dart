import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:get/get.dart';

Future<void> showStatusDialog(
  BuildContext context, {
  MediaStatus? toUpdateStatus,
}) async {
  final controller = Get.find<StatusController>();

  final bool isEditing = (toUpdateStatus != null);

  controller.initStatusForm(toUpdateStatus);

  await Get.dialog(
    AlertDialogBase(
      isEditing: isEditing,
      label: 'Status',
      onSubmit: () async {
        if (isEditing) {
          await controller.updateStatus();
        } else {
          await controller.addStatus();
        }
      },
      children: [
        // Status Content
        CustomTextField(
          labelText: 'Status Name',
          hintText: 'e.g., Completed, Plan To Watch, Dropped',
          onChanged: (value) => controller.statusName.value = value,
          initialValue: controller.statusName.value,
        ),

        const SizedBox(height: 16),
        // Status color
        Obx(
          () => ColorPickerField(
            initialColor: controller.statusColor.value,
            onColorChanged: (Color newColor) {
              controller.statusColor.value = newColor;
            },
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
