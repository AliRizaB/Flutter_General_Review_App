import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<bool> deleteConfirmDialog({required String title}) async {
  final theme = Get.theme;
  final result = await Get.defaultDialog<bool>(
    title: "Delete \"$title\"",
    content: const Text('Are you sure?'),
    titleStyle: TextStyle(
      color: theme.colorScheme.onErrorContainer,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),

    backgroundColor: theme.colorScheme.errorContainer.withAlpha(120),

    textConfirm: 'Delete',
    confirmTextColor: theme.colorScheme.onError,
    buttonColor: theme.colorScheme.error,
    onConfirm: () => Get.back(result: true),

    textCancel: 'Cancel',
    cancelTextColor: theme.colorScheme.error,
    onCancel: () {
      // Get.defaultDialog closes automatically on cancel tap
    },
  );
  return result ?? false;
}
