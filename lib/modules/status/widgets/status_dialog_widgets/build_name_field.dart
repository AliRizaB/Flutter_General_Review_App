import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';

TextFormField buildStatusNameField(StatusController controller) {
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