import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:get/get.dart';

Obx statusSelectorDropdown(
  MediaController mediaController,
  StatusController statusController,
) {
  return Obx(() {
    final int? selectedValue = mediaController.statusId.value == -1
        ? null
        : mediaController.statusId.value;

    return DropdownButtonFormField<int>(
      initialValue: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Select Status'),
      items: statusController.statuses
          .map(
            (e) => DropdownMenuItem(
              value: e.id!,
              child: Text(e.name, style: TextStyle(color: e.getColor)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          mediaController.statusId.value = value;
        }
      },
      validator: (value) {
        if (value == null || value == -1) {
          return 'Please select status';
        }
        return null;
      },
    );
  });
}
