import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/theme_service.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Obx themeModeSelection(ThemeService themeService) {
  return Obx(
    () => SizedBox(
      width: double.infinity,
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.wb_sunny_outlined, size: 18),
            label: Text('Light', style: TextStyle(fontSize: 12)),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode_outlined, size: 18),
            label: Text('Dark', style: TextStyle(fontSize: 12)),
          ),
        ],
        selected: {themeService.themeMode.value},
        onSelectionChanged: (newSelection) {
          themeService.changeThemeMode(newSelection.first);
        },
      ),
    ),
  );
}
