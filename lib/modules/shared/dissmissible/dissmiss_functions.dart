import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwipeBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Alignment alignment;

  const SwipeBackground({
    super.key,
    required this.color,
    required this.icon,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: alignment,
      child: Icon(icon),
    );
  }
}

Future<bool> handleDismiss({
  required BuildContext context,
  required DismissDirection direction,
  required String itemTitle,
  required Future<void> Function() onDelete,
  required VoidCallback onEdit,
}) async {
  if (direction == DismissDirection.endToStart) {
    // Swipe Left -> Delete
    final confirmed = await deleteConfirmDialog(title: itemTitle);

    if (confirmed) {
      await onDelete();
      return true;
    }
    return false;
  } else {
    onEdit();

    return false;
  }
}

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
