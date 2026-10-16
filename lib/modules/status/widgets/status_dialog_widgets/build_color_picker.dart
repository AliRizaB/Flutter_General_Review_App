import 'dart:ui';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Obx buildColorPicker(StatusController controller) {
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