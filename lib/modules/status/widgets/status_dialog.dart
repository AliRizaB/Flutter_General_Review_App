import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/build_color_picker.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';
import 'package:get/get.dart';

Future<void> showStatusDialog({MediaStatus? toUpdateStatus}) async {
  final controller = Get.find<StatusController>();

  final bool isEditing = (toUpdateStatus != null);

  controller.initStatusForm(toUpdateStatus);

  await AlertDialogBase.show(
    isEditing: isEditing,
    label: 'Status',
    onSubmit: controller.onSubmit,
    children: [
      // Status Content
      CustomTextField(
        labelText: 'Status Name',
        hintText: 'e.g., Completed, Plan To Watch, Dropped',
        onChanged: (value) => controller.statusName.value = value,
        initialValue: controller.statusName.value,
      ),
      // Status color
      Obx(
        () => BuildColorPicker(
          initialColor: controller.statusColor.value,
          onColorChanged: (Color newColor) {
            controller.statusColor.value = newColor;
          },
        ),
      ),
    ],
  );
}
