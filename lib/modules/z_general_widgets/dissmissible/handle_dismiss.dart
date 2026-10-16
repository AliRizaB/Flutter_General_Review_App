import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/delete_confirmation.dart';


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

    if (confirmed == true) {
      await onDelete();
      return true;
    }
    return false;
  } else {
    onEdit();

    return false;
  }
}
