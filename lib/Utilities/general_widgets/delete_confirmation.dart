import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<bool> deleteConfirmDialog(
  ThemeData theme, {
  required String title,
}) async {
  return await Get.defaultDialog<bool>(
        titleStyle: TextStyle(overflow: TextOverflow.ellipsis),
        title: "Delete \"$title\"",
        content: const Text('Are you sure?'),

        backgroundColor: theme.colorScheme.errorContainer.withAlpha(120),

        textConfirm: 'YES',
        onConfirm: () {
          Get.back(result: true);
        },

        buttonColor: theme.colorScheme.error,

        cancelTextColor: Colors.white,
        textCancel: 'no',
        onCancel: () => false,
      ) ??
      false;
}
